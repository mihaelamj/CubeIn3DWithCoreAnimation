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
      VStack {
        CubeSideView(number: 1, color1: .blue, color2: .purple, sideSize: 300)
        CubeSideView(number: 2, color1: .red, color2: .pink, sideSize: 300)
        CubeSideView(number: 3, color1: .green, color2: .blue, sideSize: 300)
        CubeSideView(number: 4, color1: .yellow, color2: .orange, sideSize: 300)
        CubeSideView(number: 5, color1: .purple, color2: .pink, sideSize: 300)
        CubeSideView(number: 6, color1: .blue, color2: .black, sideSize: 300)
//        CubeFlat()
      }
    }
}


