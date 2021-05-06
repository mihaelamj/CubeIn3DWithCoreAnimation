//
//  AView+Custom.swift
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

extension AView {
  static func makeSideView(number: Int, width: CGFloat) -> CustomLayerView {
    let color = AColor.colorForCubeSide(number: number)
    let view = CustomLayerView(text: "\(number)", color: color, side: width)
    
    let myAnchorPointAndPosition = CGPoint.anchorPointAndPositionForCubeSideLayer(number: number, sideSize: width)
    
    #if os(iOS) || os(tvOS)
    view.layer.anchorPoint = myAnchorPointAndPosition.anchorPoint
    view.layer.position = myAnchorPointAndPosition.position
    #endif

    #if os(OSX)
    view.layer?.anchorPoint = myAnchorPointAndPosition.anchorPoint
    view.layer?.position = myAnchorPointAndPosition.position
    #endif
    
    return view
  }
}
