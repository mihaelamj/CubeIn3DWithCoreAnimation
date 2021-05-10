//
//  CACube3DView.swift
//  Cube3DCAMac
//
//  Created by Mihaela Mihaljevic Jakic on 06.05.2021..
//

import Foundation

//         +-------+
//         |       |
//         |   5   |
//         |       |
//         +-------+
//+-------++-------++-------+
//|       ||       ||       |
//|   1   ||  2/4  ||   3   |
//|       ||       ||       |
//+-------++-------++-------+
//         +-------+
//         |       |
//         |   6   |
//         |       |
//         +-------+


import Foundation
import AllApples

#if os(iOS) || os(tvOS)
import UIKit
#endif

#if os(OSX)
import Cocoa
#endif

public class CACube3DView: GestureRecognizerView {
  
  // MARK: -
  // MARK: Properties -
  
  private(set) public lazy var transformedLayer: CALayer = {
    let l = CATransformLayer()
    l.name = "Transform Layer"
    #if os(OSX)
    l.isGeometryFlipped = true
    #endif
    return l
  }()
  
  #if os(iOS) || os(tvOS)
  static let sideWidth: CGFloat = 60.0
  #endif
  
  #if os(OSX)
  static let sideWidth: CGFloat = 150.0
  #endif
  
  public var doubleSideWidth: CGFloat {
    return CACube3DView.sideWidth * 2.0
  }
  
  private(set) public lazy var side1: CustomLayerView = {
    let view = AView.makeSideView(number: 1, width: doubleSideWidth)
    return view
  }()
  
  private(set) public lazy var side2: CustomLayerView = {
    let view = AView.makeSideView(number: 2, width: doubleSideWidth)
    return view
  }()
  
  private(set) public lazy var side3: CustomLayerView = {
    let view = AView.makeSideView(number: 3, width: doubleSideWidth)
    return view
  }()
  
  private(set) public lazy var side4: CustomLayerView = {
    let view = AView.makeSideView(number: 4, width: doubleSideWidth)
    return view
  }()
  
  private(set) public lazy var side5: CustomLayerView = {
    let view = AView.makeSideView(number: 5, width: doubleSideWidth)
    return view
  }()
  
  private(set) public lazy var side6: CustomLayerView = {
    let view = AView.makeSideView(number: 6, width: doubleSideWidth)
    return view
  }()
  
  // MARK: -
  // MARK: Template Overrides -
  
  override public func customInit() {
    super.customInit()
    setupTransformLayer()
    setupCube()
  }
  
}

// MARK: -
// MARK: Setup Layers -

private extension CACube3DView {
  
  func setupTransformLayer() {
    
    #if os(OSX)
    assert(myLayer != nil, "Error: `myLayer` == `nil`")
    #endif
    
    transformedLayer.bounds = bounds
    transformedLayer.anchorPoint = .zero
    transformedLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
    
    #if os(OSX)
    let myBounds = myLayer?.bounds ?? .zero
    assert(myBounds != .zero, "Error: `myBounds` == `.zero`")
    #endif
    
    myLayer?.addSublayer(transformedLayer)
    
    #if os(OSX)
    if let myRealLayer = myLayer {
      assert(transformedLayer.bounds == myRealLayer.bounds, "Error: `transformedLayer.bounds` != `myLayer.bounds`")
    } else {
      fatalError("Error: `myLayer` == `nil`!")
    }
    #endif
  }
  
  func setupCube() {
    
    // INFO: set up the initial sublayer transform -
    let perspective = CATransform3D.somePerspectiveTransform()
    setInitialSublayerTransform(perspective)
    
    // INFO: Intially the cube is flattened
    for index in 1...6 {
      let view = getSideSubview(number: index)
      addSideSubview(view)
    }
  }
  
  func setInitialSublayerTransform(_ transform: CATransform3D) {
    transformedLayer.sublayerTransform = transform
  }
  
  func getSideSubview(number: Int) -> AView {
    var view = side1
    switch number {
      case 2:
        view = side2
        break
      case 3:
        view = side3
        break
      case 4:
        view = side4
        break
      case 5:
        view = side5
        break
      case 6:
        view = side6
        break
      default:
        ()
    }
    return view
  }
  
  func addSideSubview(_ subview: AView) {
    addSubview(subview)
    
    #if os(iOS) || os(tvOS)
    transformedLayer.addSublayer(subview.layer)
    #endif
    
    #if os(OSX)
    if let aLayer = subview.layer {
      transformedLayer.addSublayer(aLayer)
    } else {
      fatalError("`subview.layer` == `nil`")
    }
    #endif
  }
  
  func set3DCube(on: Bool) {
    #if os(OSX)
    side4.layer?.zPosition = on ? CACube3DView.sideWidth : 1
    side1.layer?.transform = on ? CATransform3D.transformFor3DCubeSide(1, zWidth: CACube3DView.sideWidth)  : CATransform3DIdentity
    side2.layer?.transform = on ? CATransform3D.transformFor3DCubeSide(2, zWidth: CACube3DView.sideWidth)  : CATransform3DIdentity
    side3.layer?.transform = on ? CATransform3D.transformFor3DCubeSide(3, zWidth: CACube3DView.sideWidth)  : CATransform3DIdentity
    side4.layer?.transform = on ? CATransform3D.transformFor3DCubeSide(4, zWidth: CACube3DView.sideWidth)  : CATransform3DIdentity
    side5.layer?.transform = on ? CATransform3D.transformFor3DCubeSide(5, zWidth: CACube3DView.sideWidth)  : CATransform3DIdentity
    side6.layer?.transform = on ? CATransform3D.transformFor3DCubeSide(6, zWidth: CACube3DView.sideWidth)  : CATransform3DIdentity
    #endif

    #if os(iOS) || os(tvOS)
    side4.layer.zPosition = on ? CACube3DView.sideWidth : 1
    side1.layer.transform = on ? CATransform3D.transformFor3DCubeSide(1, zWidth: CACube3DView.sideWidth) : CATransform3DIdentity
    side2.layer.transform = on ? CATransform3D.transformFor3DCubeSide(2, zWidth: CACube3DView.sideWidth) : CATransform3DIdentity
    side3.layer.transform = on ? CATransform3D.transformFor3DCubeSide(3, zWidth: CACube3DView.sideWidth) : CATransform3DIdentity
    side4.layer.transform = on ? CATransform3D.transformFor3DCubeSide(4, zWidth: CACube3DView.sideWidth) : CATransform3DIdentity
    side5.layer.transform = on ? CATransform3D.transformFor3DCubeSide(5, zWidth: CACube3DView.sideWidth) : CATransform3DIdentity
    side6.layer.transform = on ? CATransform3D.transformFor3DCubeSide(6, zWidth: CACube3DView.sideWidth) : CATransform3DIdentity
    #endif
    
  }
  
}


// MARK: -
// MARK: Gesture Events -

public extension CACube3DView {
  
  override func rotationChanged(degrees: Float) {
    debugPrint("Rotation- degrees: \(degrees)")
  }
  
  override func rotationChanged(radians: Float) {
    debugPrint("Rotation- radians: \(radians)")
    let transform = transformedLayer.sublayerTransform
    let rot = CATransform3DRotate(transform, CGFloat(radians), 0, 1, 0)
    transformedLayer.sublayerTransform = rot
  }
  
  override func displacementChanged(displacement: CGPoint) {
    debugPrint("Moved to: \(displacement)")
    
    guard !(displacement.x == 0 && displacement.y == 0) else { return }
    
    let rotationTransform = transformedLayer.sublayerTransform.rotationFromDisplacement(displacement, sideWidth: CACube3DView.sideWidth, is3D: isOn)
    transformedLayer.sublayerTransform = rotationTransform
  }
  
  override func scaleChanged(scale: CGFloat) {
    debugPrint("Scaled: \(scale)")
    
    let scaleTransform = CATransform3DScale(transformedLayer.sublayerTransform, scale, scale, scale)
    transformedLayer.sublayerTransform = scaleTransform
  }
  
  override func tapHappened() {
    set3DCube(on: isOn)
  }
  
}

