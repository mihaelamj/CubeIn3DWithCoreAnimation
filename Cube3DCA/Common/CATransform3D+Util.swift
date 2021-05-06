//
//  CATransform3D+Util.swift
//  Cube3DCAMac
//
//  Created by Mihaela Mihaljevic Jakic on 06.05.2021..
//

#if os(iOS) || os(tvOS)
import UIKit
#endif

#if os(OSX)
import Cocoa
#endif

// MARK: -
// MARK: Rotation From Moving a Finger -

public extension CATransform3D {
  
  func rotationFromDisplacement(_ displacement: CGPoint, sideWidth: CGFloat, is3D: Bool) -> CATransform3D {
    
    var currentTransform = self
    
    let totalRotation: CGFloat = sqrt(displacement.x * displacement.x + displacement.y * displacement.y)
    let angle: CGFloat = totalRotation * .pi / 180.0
    
    let xRotationFactor = displacement.x / angle
    let yRotationFactor = displacement.y / angle
    
    if is3D {
      currentTransform = CATransform3DTranslate(currentTransform, 0, 0, sideWidth / 2.0)
    }
    
    var rotationalTransform = CATransform3DRotate(currentTransform, angle,
                                                  (xRotationFactor * currentTransform.m12 - yRotationFactor * currentTransform.m11),
                                                  (xRotationFactor * currentTransform.m22 - yRotationFactor * currentTransform.m21),
                                                  (xRotationFactor * currentTransform.m32 - yRotationFactor * currentTransform.m31))
    
    if (is3D) {
      rotationalTransform = CATransform3DTranslate(rotationalTransform, 0, 0, -sideWidth / 2.0);
    }
    
    return rotationalTransform
  }
}

// MARK: -
// MARK: A Little Perspective-

public extension CATransform3D {
  static func somePerspectiveTransform() -> CATransform3D {
    var perspective = CATransform3DIdentity;
    perspective.m34 = -1.0 / 500.0;
    perspective = CATransform3DRotate(perspective, CGFloat(Double.pi) / 8, 1, 0, 0);
    perspective = CATransform3DRotate(perspective, CGFloat(Double.pi) / 8, 0, 1, 0);
    perspective = CATransform3DScale(perspective, 0.7, 0.7, 0.7)
    return perspective
  }
}

// MARK: -
// MARK: 3D Cube -

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

public extension CATransform3D {
  static func transformFor3DCubeSide(_ number: Int, zWidth: CGFloat) -> CATransform3D {
    
    let halfPi = CGFloat(Double.pi) / 2.0
    var trans = CATransform3DIdentity
    
    switch number {
      case 1:
        trans = CATransform3DMakeRotation(halfPi, 0, 1, 0) // 1 - rotated +90° on the `Y` axes
        break
      case 2:
        trans = CATransform3DIdentity // 2 - stays the same
        break
      case 3:
        trans = CATransform3DMakeRotation(-halfPi, 0, 1, 0) // 3 - rotated -90° on the `Y` axes
        break
      case 4:
        trans = CATransform3DMakeTranslation(0, 0, zWidth) // same as setting the `zPosition`, broght up-front by the `width`, side of our cube
        break
      case 5:
        trans = CATransform3DMakeRotation(-halfPi, 1, 0, 0) // 5 - rotated -90° on the `X` axes
        break
      case 6:
        trans = CATransform3DMakeRotation(halfPi, 1, 0, 0) // 6 - rotated +90° on the `X` axes
        break
      default:
        break
    }
    
    return trans
  }
}
