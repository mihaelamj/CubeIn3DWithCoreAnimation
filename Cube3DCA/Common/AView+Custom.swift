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
    
    //         +-------+
    //         |       |
    //         |   5   |
    //         |       |
    //         +-------+
    //+-------++-------++-------++-------+
    //|       ||       ||       ||       |
    //|   1   ||   2   ||   3   ||   4   |
    //|       ||       ||       ||       |
    //+-------++-------++-------++-------+
    //         +-------+
    //         |       |
    //         |   6   |
    //         |       |
    //         +-------+
    
    // INFO: Put layer 4 in fron of layer 2, instead of as in the picture above, rigth to the layer 3 -
    
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
    
    if number == 4 {
      #if os(iOS) || os(tvOS)
      view.layer.zPosition = 1
      #endif

      #if os(OSX)
      view.layer?.zPosition = 1
      #endif
    }
    
    return view
  }
}
