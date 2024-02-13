//
//  ContentView.swift
//  ThinkDrawing
//
//  Created by Ravi Kishore on 13/02/24.
//

import SwiftUI

struct Triangle: Shape {
  func path(in rect: CGRect) -> Path {
       var path = Path()
    path.move(to: CGPoint(x: rect.midX, y: rect.minY))
    path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
    path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
    path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
    
    return path
  }
}

struct Arc: Shape {
  let startAngle: Angle
  let endAngle: Angle
  let clockWise: Bool
  
  func path(in rect: CGRect) -> Path {
    
    let rotationAdjustment = Angle.degrees(90)
    let modifiedStart = startAngle - rotationAdjustment // -90
    let modifiedEnd = endAngle - rotationAdjustment // 110 - 90 = 30
    
    
      var path = Path()
    path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width/2, startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: clockWise)
    
      return path
  }
}

struct Flower: Shape {
  // How much to move this petal away from the center
  var petalOffset: Double = -20
  
  // How Wide to make each petal
  var petalWidth : Double = 100
  
  func path(in rect: CGRect) -> Path {
    // The path will hold all petals
    var path = Path()
  
    // Count from 0 up to pi * 2 , moving from pi / 8 each time
    for number in stride(from: 0, to: Double.pi * 2, by: Double.pi / 8) {
       // Rotate the petal by the current value of our loop
       let rotation = CGAffineTransform(rotationAngle: number)
      
       // move the petal to be at center of out view
      let position = rotation.concatenating(CGAffineTransform(translationX: rect.width / 2,
                                                              y: rect.height / 2))
      
      // Create a path for this petal using our properties plus a fixed Y and height
      let originalPetal = Path(ellipseIn: CGRect(x: petalOffset,
                                                 y: 0,
                                                 width: petalWidth,
                                                 height: rect.width / 2))
      
      // apply our rotation/position transformation to the petal
      let rotatedPetal = originalPetal.applying(position)
      
      // add it to our main path
      path.addPath(rotatedPetal)
    }
    
    // now send the main path back
    return path
  }
}

struct ContentView: View {
  @State private var petalOffset = -20.0
  @State private var petalWidth = 100.0
  
  var body: some View {
    VStack {
       Flower(petalOffset: petalOffset, petalWidth: petalWidth)
        .fill(.red, style: FillStyle(eoFill: true))
      
      Text("Offset")
      Slider(value: $petalOffset, in: -40...40)
      
      Text("Width")
      Slider(value: $petalWidth, in: 0...100)
        .padding(.horizontal)
    }
  }
}


extension ContentView {
  var arcView: some View {
    Arc(startAngle: .zero, endAngle: .degrees(110), clockWise: false)
      .stroke(.blue, lineWidth: 10)
      .frame(width: 300, height: 300)
  }
  
  var triangleView: some View {
    Triangle()
    .stroke(.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
    .frame(width: 300, height: 300)
  }
}

#Preview {
    ContentView()
}
