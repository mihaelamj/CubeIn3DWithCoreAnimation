//
//  CustomLayerView.swift
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

public class CustomLayerView: PlainLayerView {
  //static func makeCustomDemoView(text: String, color: AColor, side: CGFloat) -> AView {
  
  // MARK: -
  // MARK: Properties -
  
  private(set) public var text: String = "*"
  private(set) public var color: AColor = .red
  private(set) public var side: CGFloat = 100.0
  
  // MARK: -
  // MARK: Init -
  
  required init(text: String, color: AColor, side: CGFloat) {
    self.text = text
    self.color = color
    self.side = side
    super.init(layerName: "Custom Layer: `\(text)`")
    makeMe(sideWidth: side)
  }
  
  required init(layerName: String) {
    fatalError("init(layerName:) has not been implemented")
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension CustomLayerView {
  
  func makeMe(sideWidth: CGFloat) {
    // INFO: Make Me
    frame = CGRect(x: 0, y: 0, width: side, height: side)
    myColor = color
    
    // INFO: Add Text layer -
    let tl = CustomLayerView.makeTextLayer(text: text, color: color, side: side)
    tl.frame = frame
    tl.position = CGPoint(x: 0, y: 0)
    myLayer?.addSublayer(tl)
    
    // INFO: Style me -
    CustomLayerView.styleMyLayer(myLayer, sideWidth: sideWidth)
  }
  
  static func makeTextLayer(text: String, color: AColor, side: CGFloat) -> CATextLayer {
    let tl = CATextLayer()
    tl.string = text
    tl.fontSize = side * 0.85
    tl.foregroundColor = AColor.white.cgColor
    tl.backgroundColor = color.cgColor
    tl.anchorPoint = CGPoint(x: 0, y: 0)
    tl.alignmentMode = .center
    #if os(iOS) || os(tvOS)
    tl.isGeometryFlipped = true
    #endif
    return tl
  }
  static func styleMyLayer(_ lay: CALayer?, sideWidth: CGFloat) {
    let cornerRadius: CGFloat = sideWidth * 0.3
    lay?.borderColor = AColor.white.cgColor
    lay?.borderWidth = sideWidth * 0.1
    
    lay?.shadowRadius = 33.0
    lay?.shadowColor = AColor.black.cgColor
    lay?.shadowOpacity = 0.5
    
    lay?.cornerRadius = cornerRadius
    lay?.masksToBounds = true
  }
}
