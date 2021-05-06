//
//  BaseTransformView.swift
//  Cube3DCAMac
//
//  Created by Mihaela Mihaljevic Jakic on 06.05.2021..
//

import Foundation

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
  public override var wantsUpdateLayer : Bool {
    get {  return true }
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
    wantsLayer = true
    layer = CALayer()
    myLayer?.isGeometryFlipped = true
    frame = CGRect(x: 0, y: 0, width: 1000, height: 1000)
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
}
