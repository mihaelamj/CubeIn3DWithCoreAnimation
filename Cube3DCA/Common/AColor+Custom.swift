//
//  AColor+Custom.swift
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

extension AColor {
  static func colorForCubeSide(number: Int) -> AColor {
    var color = AColor.systemTeal
    
    switch number {
      case 1:
        color = AColor.systemBlue
        break
      case 2:
        color = AColor.systemRed
        break
      case 3:
        color = AColor.systemGreen
        break
      case 4:
        color = AColor.systemPurple
        break
      case 5:
        color = AColor.systemGray
        break
      case 6:
        color = AColor.systemYellow
        break
      default:
        color = AColor.systemBlue
        break
    }
    
    return color
  }
}

