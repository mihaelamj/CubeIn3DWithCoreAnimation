//
//  Cube3DSwiftUIApp.swift
//  Shared
//
//  Created by Mihaela Mihaljevic Jakic on 09.05.2021..
//

import SwiftUI

@main
struct Cube3DSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct CubeInnerSideView: View {
  var number: Int
  var color1, color2: Color
  var sideSize: CGFloat
  
  var body: some View {
    
    let font = Font.system(.largeTitle).bold()
    
    return
      Text("\(number)")
      .font(font).scaleEffect(8)
      .fixedSize(horizontal: true, vertical: true)
      .frame(width: sideSize, height: sideSize)
      .background(
        LinearGradient(gradient:
                        Gradient(colors: [color1, color2]), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1)))
      .clipShape(RoundedRectangle(cornerRadius: sideSize / 2.7, style: .continuous))
  }
}

struct CubeSideView: View {
  @State private var animate = false
  var number: Int
  var color1, color2: Color
  var sideSize: CGFloat
  
  var body: some View {
    
    let gap: CGFloat = 20
    return
      ZStack {
      
        RoundedRectangle(cornerRadius: sideSize / 2.7, style: .continuous)
          .frame(width: sideSize, height: sideSize)
          .foregroundColor(.white)
        
        .frame(width: sideSize, height: sideSize)
        .fixedSize(horizontal: true, vertical: true)
        
        CubeInnerSideView(number: number, color1: color1, color2: color2, sideSize: sideSize - gap)
      }
  }
}

struct CubeSideEffect: GeometryEffect {
  
  @Binding var flat: Bool
  
  var angle: Double
  var side: Int
  let axis: (x: CGFloat, y: CGFloat)
  
  var animatableData: Double {
    get { angle }
    set { angle = newValue }
  }
  
  func effectValue(size: CGSize) -> ProjectionTransform {
    
    let a = CGFloat(Angle(degrees: angle).radians)
    var transform3d = CATransform3DIdentity;
    transform3d.m34 = -1/max(size.width, size.height)
    
    transform3d = CATransform3DRotate(transform3d, a, axis.x, axis.y, 0)
    transform3d = CATransform3DTranslate(transform3d, -size.width/2.0, -size.height/2.0, 0)
    
    let affineTransform = ProjectionTransform(CGAffineTransform(translationX: size.width/2.0, y: size.height / 2.0))
    
    return ProjectionTransform(transform3d).concatenating(affineTransform)
  }
  
}

struct FlipEffect: GeometryEffect {
  
  var animatableData: Double {
    get { angle }
    set { angle = newValue }
  }
  
  @Binding var flipped: Bool
  var angle: Double
  let axis: (x: CGFloat, y: CGFloat)
  
  func effectValue(size: CGSize) -> ProjectionTransform {
    
    // We schedule the change to be done after the view has finished drawing,
    // otherwise, we would receive a runtime error, indicating we are changing
    // the state while the view is being drawn.
    DispatchQueue.main.async {
      self.flipped = self.angle >= 90 && self.angle < 270
    }
    
    let a = CGFloat(Angle(degrees: angle).radians)
    
    var transform3d = CATransform3DIdentity;
    transform3d.m34 = -1/max(size.width, size.height)
    
    transform3d = CATransform3DRotate(transform3d, a, axis.x, axis.y, 0)
    transform3d = CATransform3DTranslate(transform3d, -size.width/2.0, -size.height/2.0, 0)
    
    let affineTransform = ProjectionTransform(CGAffineTransform(translationX: size.width/2.0, y: size.height / 2.0))
    
    return ProjectionTransform(transform3d).concatenating(affineTransform)
    // .rotationEffect(Angle(degrees: 45), anchor: .center)
  }
}

struct Cube3DEffect: GeometryEffect {
  
  var cubeSide: Int
  var sideSize: CGFloat
  var displacement: CGPoint
  
  @Binding var is3D: Bool

  func cube3DTransformForSide(_ side: Int, zWidth: CGFloat) -> CATransform3D {
    let halfPi = CGFloat(Double.pi) / 2.0
    var trans = CATransform3DIdentity
    switch side {
      case 1:
        trans = CATransform3DMakeRotation(halfPi, 0, 1, 0) // 1 - rotated +90° on the `Y` axes
        break
      case 2:
        break // 2 - stays the same
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
  
  func flatCubeTransformForSide(_ side: Int, zWidth: CGFloat) -> CATransform3D {
    let halfPi = CGFloat(Double.pi) / 2.0
    let halfSideSize: CGFloat = sideSize / 2.0
    var trans = CATransform3DIdentity
    
    switch side {
      case 1:
        trans = CATransform3DTranslate(trans, -halfSideSize, 0, 0) // moved to the left
        break
      case 2: // stays the same
        break
      case 3:
        trans = CATransform3DTranslate(trans, halfSideSize, 0, 0) // moved to the right
        break
      case 4:
        trans = CATransform3DMakeTranslation(0, 0, zWidth) // same as setting the `zPosition`, broght up-front by the `width`, side of our cube
        break
      case 5:
        trans = CATransform3DTranslate(trans, 0, -halfSideSize, 0) // moved up
        break
      case 6:
        trans = CATransform3DTranslate(trans, 0, halfSideSize, 0) // moved down
        break
      default:
        break
    }
    return trans
  }
  
  func rotationFromDisplacement(_ displacement: CGPoint, transform: CATransform3D, sideWidth: CGFloat, is3D: Bool) -> CATransform3D {
    var currentTransform = transform
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
  
  func effectValue(size: CGSize) -> ProjectionTransform {
    return ProjectionTransform(CATransform3DIdentity)
  }
  
}

struct FlatCubeEffect: GeometryEffect {
  var cubeSide: Int
  var sideSize: CGFloat
  @Binding var isInCubePosition: Bool
  var transform3D: CATransform3D
  
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
  
  func flatCubeTransformForSide(_ side: Int, zWidth: CGFloat) -> CATransform3D {
    let halfPi = CGFloat(Double.pi) / 2.0
    let halfSideSize: CGFloat = sideSize / 2.0
    var trans = CATransform3DIdentity
    
    switch side {
      case 1:
        trans = CATransform3DTranslate(trans, -halfSideSize, 0, 0) // moved to the left
        break
      case 2: // stays the same
        break
      case 3:
        trans = CATransform3DTranslate(trans, halfSideSize, 0, 0) // moved to the right
        break
      case 4:
        trans = CATransform3DMakeTranslation(0, 0, zWidth) // same as setting the `zPosition`, broght up-front by the `width`, side of our cube
        break
      case 5:
        trans = CATransform3DTranslate(trans, 0, -halfSideSize, 0) // moved up
        break
      case 6:
        trans = CATransform3DTranslate(trans, 0, halfSideSize, 0) // moved down
        break
      default:
        break
    }
    return trans
  }
  
  var animatableData: CATransform3D {
    get { transform3D }
    set { transform3D = newValue }
  }
  
  func effectValue(size: CGSize) -> ProjectionTransform {
    return ProjectionTransform(CATransform3DIdentity)
  }
}

struct Cube3D: View {
  
  @State private var animate3d = false
  
  let side: CGFloat
  
  init(side: CGFloat) {
    self.side = side
  }
  
  let side1 = CubeSideView(number: 1, color1: .blue, color2: .purple, sideSize: 300)
  let side2 = CubeSideView(number: 2, color1: .red, color2: .pink, sideSize: 300)
  let side3 = CubeSideView(number: 3, color1: .green, color2: .blue, sideSize: 300)
  let side4 = CubeSideView(number: 4, color1: .yellow, color2: .orange, sideSize: 300)
  let side5 = CubeSideView(number: 5, color1: .purple, color2: .pink, sideSize: 300)
  let side6 = CubeSideView(number: 6, color1: .blue, color2: .black, sideSize: 300)
  
  var body: some View {
    return ZStack {
      side1
      side2
      side3
      side4
      side5
      side6
    }
    .frame(width: 900, height: 900)
    .fixedSize(horizontal: true, vertical: true)
  }
}



struct CubeFlat: View {
  var body: some View {
    return ZStack {
      CubeSideView(number: 1, color1: .blue, color2: .purple, sideSize: 300)
      CubeSideView(number: 2, color1: .red, color2: .pink, sideSize: 300)
      CubeSideView(number: 3, color1: .green, color2: .blue, sideSize: 300)
      CubeSideView(number: 4, color1: .yellow, color2: .orange, sideSize: 300)
      CubeSideView(number: 5, color1: .purple, color2: .pink, sideSize: 300)
      CubeSideView(number: 6, color1: .blue, color2: .black, sideSize: 300)
    }
  }
}

struct CubeSideView_Previews: PreviewProvider {
    static var previews: some View {
      Cube3D(side: 100.0)
//      VStack {
//        CubeSideView(number: 1, color1: .blue, color2: .purple, sideSize: 300)
//          .rotation3DEffect(Angle(degrees: 90.0),
//                            axis: (x: 0.14, y: 1, z: 1),
//                                       anchor: .bottomTrailing,
//                                       anchorZ: -100,
//                                       perspective: 0.0002)
//        CubeSideView(number: 2, color1: .red, color2: .pink, sideSize: 300)
//        CubeSideView(number: 3, color1: .green, color2: .blue, sideSize: 300)
//        CubeSideView(number: 4, color1: .yellow, color2: .orange, sideSize: 300)
//        CubeSideView(number: 5, color1: .purple, color2: .pink, sideSize: 300)
//        CubeSideView(number: 6, color1: .blue, color2: .black, sideSize: 300)
//        CubeFlat()
      
    }
}


