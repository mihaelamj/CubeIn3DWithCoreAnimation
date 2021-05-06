//
//  GestureRecognizerView.swift
//  Cube3DCAMac
//
//  Created by Mihaela Mihaljevic Jakic on 06.05.2021..
//

import Foundation

//
//  GestureRecognizerView.swift
//  3DCubeWithCA
//
//  Created by Mihaela Mihaljevic Jakic on 05.05.2021..
//

import Foundation
import AllApples

#if os(iOS) || os(tvOS)
import UIKit
#endif

#if os(OSX)
import Cocoa
#endif

public class GestureRecognizerView: PlainLayerView {
  var isOn: Bool = false

  
  // MARK: -
  // MARK: Template Overrides -
  
  override public func customInit() {
    super.customInit()
    setupRecognizers()
  }
}


// MARK: -
// MARK: Setup  -

private extension GestureRecognizerView {
  
  func setupRecognizers() {
    setupPanGestureRecognizer()
    
    #if os(OSX)
    setupClickGestureRecognizer()
    #endif
    
    #if os(iOS) || os(tvOS)
    setupRotationDetector()
    setupPinchGestureRecognizer()
    setupTapGestureRecognizer()
    #endif
  }
  
}

// MARK: -
// MARK: Rotation  -

extension GestureRecognizerView {
  
  #if os(OSX)
  public override func rotate(with event: NSEvent) {
    let rotation = event.rotation
    debugPrint("rotation in degrees is: \(rotation)")
    let radians = rotation * .pi / 180
    handleRotation(radians: Float(radians))
    handleRotation(degrees: Float(rotation))
  }
  #endif
  
  #if os(iOS) || os(tvOS)
  private func setupRotationDetector() {
    let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotateGesture(_:)))
    self.addGestureRecognizer(rotateGesture)
  }
  
  @objc func handleRotateGesture(_ gestureRecognizer: UIRotationGestureRecognizer) {
    let rotation = gestureRecognizer.rotation // in radians
    let degrees = rotation * 180 / .pi
    handleRotation(radians: Float(rotation))
    handleRotation(degrees: Float(degrees))
    gestureRecognizer.rotation = 0
  }
  #endif
}

// MARK: -
// MARK: Movement  -

extension GestureRecognizerView {
  
  #if os(OSX)
  private func setupPanGestureRecognizer() {
    let panGR = NSPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
    addGestureRecognizer(panGR)
  }
  
  @objc func handlePanGesture(_ gestureRecognizer: NSPanGestureRecognizer) {
    let displacement: CGPoint = gestureRecognizer.translation(in: self)
    handlePan(displacement: displacement, changed: gestureRecognizer.state == .changed)
  }
  #endif
  
  #if os(iOS) || os(tvOS)
  private func setupPanGestureRecognizer() {
    let panGR = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
    addGestureRecognizer(panGR)
  }
  
  @objc func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
    let displacement: CGPoint = gestureRecognizer.translation(in: self)
    
    handlePan(displacement: displacement, changed: gestureRecognizer.state == .changed)
    
    if gestureRecognizer.state == .changed {
      gestureRecognizer.setTranslation(.zero, in: self)
    }
  }
  #endif
  
}

// MARK: -
// MARK: Scale  -

extension GestureRecognizerView {
  
  #if os(OSX)
  public override func magnify(with event: NSEvent) {
    let magnification = event.magnification
    handleMagnification(magnification: magnification)
  }
  #endif
  
  #if os(iOS) || os(tvOS)
  private func setupPinchGestureRecognizer() {
    let pinchGR = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
    addGestureRecognizer(pinchGR)
  }
  
  @objc func handlePinchGesture(_ gestureRecognizer : UIPinchGestureRecognizer) {
    guard gestureRecognizer.view != nil else { return }
    let scale = gestureRecognizer.scale
    handleScale(scale: scale)
    gestureRecognizer.scale = 1
  }
  
  #endif
}

// MARK: -
// MARK: Click / Tap  -

extension GestureRecognizerView {
  
  #if os(OSX)
  private func setupClickGestureRecognizer() {
    let clickGR = NSClickGestureRecognizer(target: self, action: #selector(click(_:)))
    addGestureRecognizer(clickGR)
  }
  
  @objc func click(_ gestureRecognizer: NSClickGestureRecognizer) {
    if gestureRecognizer.state == .ended {
      handleClickTap()
    }
  }
  #endif
  
  #if os(iOS) || os(tvOS)
  private func setupTapGestureRecognizer() {
    let tapGR = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
    addGestureRecognizer(tapGR)
  }
  
  @objc func handleTapGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
    if gestureRecognizer.state == .ended {
      handleClickTap()
    }
  }
  #endif
}


// MARK: -
// MARK: Handling gestures,  -

private extension GestureRecognizerView {
  
  @objc func handleRotation(radians: Float) {
    debugPrint("Rotation in radians: \(radians)")
    rotationChanged(radians: radians)
  }
  
  @objc func handleRotation(degrees: Float) {
    debugPrint("Rotation in degrees: \(degrees)")
    rotationChanged(degrees: degrees)
  }
  
  @objc  func handlePan(displacement: CGPoint, changed: Bool) {
    guard changed == true else { return }
    debugPrint("Displacement point: \(displacement)")
    displacementChanged(displacement: displacement)
  }
  
  @objc func handleScale(scale: CGFloat) {
    // scale
    debugPrint("Scale: \(scale)")
    scaleChanged(scale: scale)
  }
  
  @objc func handleMagnification(magnification: CGFloat) {
    // scale
    debugPrint("Magnification: \(magnification)")
    scaleChanged(scale: 1 + magnification)
  }
  
  @objc func handleClickTap() {
    isOn.toggle()
    debugPrint("Tap, isOn: \(isOn)")
    tapHappened()
  }
}

// MARK: -
// MARK: Template Methods,  -

public extension GestureRecognizerView {
  @objc func rotationChanged(degrees: Float) {}
  
  @objc func rotationChanged(radians: Float) {}
  
  @objc func displacementChanged(displacement: CGPoint) {}
  
  @objc func scaleChanged(scale: CGFloat) {}
  
  @objc func tapHappened() {}
}
