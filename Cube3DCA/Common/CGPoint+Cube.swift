//
//  CGPoint+Cube.swift
//  Cube3DCAMac
//
//  Created by Mihaela Mihaljevic Jakic on 06.05.2021..
//

import Foundation

#if os(iOS) || os(tvOS)
import UIKit
#endif

#if os(OSX)
import Cocoa
#endif

public extension CGPoint {
  static func anchorPointAndPositionForCubeSideLayer(number: Int, sideSize: CGFloat) -> (anchorPoint: CGPoint, position: CGPoint) {
    
    var resultAnchorPoint = CGPoint(x:0.5, y:0.5)
    var resultPosition = CGPoint(x:0.0, y:0.0)
    let halfSideSize: CGFloat = sideSize / 2.0

    let xOffset: CGFloat = 300.0
    let yOffset: CGFloat = 500.0
    
    switch number {
      case 1:
        resultAnchorPoint = CGPoint(x:1.0, y:0.5)  // 1 - right
        resultPosition = CGPoint(x:-halfSideSize + xOffset, y:0.0 + yOffset)
        break
      case 2:
        resultAnchorPoint = CGPoint(x:0.5, y:0.5)  // 2 - stays the same, center
        resultPosition = CGPoint(x:0.0 + xOffset, y:0.0 + yOffset)
        break
      case 3:
        resultAnchorPoint = CGPoint(x:0.0, y:0.5)  // 3 - left
        resultPosition = CGPoint(x:halfSideSize + xOffset, y:0.0 + yOffset)
        break
      case 4:
        resultAnchorPoint = CGPoint(x:0.5, y:0.5)  // 4 - stays the same, center, Z position is different, above the layer 2
        resultPosition = CGPoint(x:0.0 + xOffset, y:0.0 + yOffset)
        break
      case 5:
        resultAnchorPoint = CGPoint(x:0.5, y:1.0)   // 5 - bottom
        resultPosition = CGPoint(x:0.0 + xOffset, y:-halfSideSize + yOffset)
        break
      case 6:
        resultAnchorPoint = CGPoint(x:0.5, y:0.0)   // 6 - top
        resultPosition = CGPoint(x:0.0 + xOffset, y:halfSideSize + yOffset)
        break
      default:
        break
    }
    
    return (anchorPoint: resultAnchorPoint, position: resultPosition)
    
  }
}
