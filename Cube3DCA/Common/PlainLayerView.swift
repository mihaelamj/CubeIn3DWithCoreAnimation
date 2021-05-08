//
//  BaseTransformView.swift
//  Cube3DCAMac
//
//  Created by Mihaela Mihaljevic Jakic on 06.05.2021..
//

import Foundation
import AllApples

#if os(iOS) || os(tvOS)
import UIKit
#endif

#if os(OSX)
import Cocoa
#endif

public class PlainLayerView: AView {
  
  // MARK: -
  // MARK: Properties -
  
  private(set) public var layerName: String = "Plain Layer"
  
  public var myLayer: CALayer? {
    get { return layer }
  }
  
  #if os(OSX)
//   allows you to safely directly access the layer
//  public override var wantsUpdateLayer : Bool {
//    get {  return true }
//  }
  #endif
  
  #if os(OSX)
  public override var isFlipped: Bool {
    return true
  }
  #endif
  
  // MARK: -
  // MARK: Init -
  
  required init(layerName: String) {
    self.layerName = layerName
    super.init(frame: .zero)
    setupLayer()
    customInit()
    afterCustomInit()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: -
  // MARK: Abstract Template -
  
  public func customInit() {}
  public func afterCustomInit() {}
  
}

// MARK: -
// MARK: Layer -

private extension PlainLayerView {
  
  private func setupLayer() {
    
    #if os(OSX)
    layer = CALayer()
    // It’s important that you set wantsLayer after you’ve set your custom layer
    wantsLayer = true
    myLayer?.isGeometryFlipped = true
    frame = CGRect(x: 0, y: 0, width: 1000, height: 1000)
    NSAnimationContext.current.allowsImplicitAnimation = true
    #endif
    
    myLayer?.name = layerName
  }
  
}

// MARK: -
// MARK: Helper methods -

public extension PlainLayerView {
  func addNewSublayer(_ sublayer: CALayer) {
    #if os(OSX)
    sublayer.isGeometryFlipped = true
    #endif
    myLayer?.addSublayer(sublayer)
  }
  
  func addNewSubview(_ subview: AView) {
    #if os(OSX)
    guard let aLayer = subview.layer else {
      fatalError("Trying to add subview with it's layer == `nil`")
    }
    #endif
    addSubview(subview)
    
    #if os(iOS) || os(tvOS)
    layer.addSublayer(subview.layer)
    #endif
    #if os(OSX)
    myLayer?.addSublayer(aLayer)
    #endif
  }
}
