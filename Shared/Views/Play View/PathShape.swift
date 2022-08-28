//
//  PathShape.swift
//  PaperSoccer
//
//  Created by Nhung Tran on 27/08/2022.
//
// https://stackoverflow.com/questions/62020789/swiftui-animate-path-shape-stroke-drawing

import SwiftUI

struct Route: Shape {
    var points: [[CGPoint]]
    var ignorePoints: [CGPoint]
    var start: CGPoint
    var startPoint: CGPoint
    var isPlayerMove: Bool
    
    init(points: [[CGPoint]], ignorePoints: [CGPoint], start: CGPoint, startPoint: CGPoint, isPlayerMove: Bool) {
        self.points = points
        self.ignorePoints = ignorePoints
        self.start = start
        
        self.startPoint = startPoint
        self.isPlayerMove = isPlayerMove
    }
    

    // make route animatable head position only
    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(startPoint.x, startPoint.y) }
        set {
            startPoint.x = newValue.first
            startPoint.y = newValue.second
            
        }
    }

    func path(in rect: CGRect) -> Path {
        Path { path in
            guard points.count >= 1 else { return }
            guard (Int(start.x) != 0 && Int(start.y) != 0) else { return}
            
            path.move(to: start)
            
//            for i in 0..<points.dropLast().count {
//                path.addLine(to: points[i])
//                if i < ignorePoints.count {
//                    path.move(to: ignorePoints[i])
//                }
//
//
//            }
            for i in 0..<points.count {
                for j in 0..<points[i].count {
                    if i == points.count - 1 && j == points[i].count - 1 {
                        break
                    }
                    path.addLine(to: points[i][j])
                    
                }
                if i < ignorePoints.count - 1 {
                    path.move(to: ignorePoints[i])
                }
                
            }

            
            if !self.isPlayerMove {
                path.addLine(to: points[points.count - 1][points[points.count - 1].count - 1])
                path.move(to: startPoint)
            }
            else {
                path.addLine(to: startPoint)
            }
        }
    }
}
//struct BotRoute: Shape {
//    var points: [[CGPoint]]
//    var ignorePoints: [CGPoint]
//    var start: CGPoint
//    var startPoint: CGPoint
//    var isPlayerMove: Bool
//    
//    init(points: [[CGPoint]], ignorePoints: [CGPoint], start: CGPoint, startPoint: CGPoint, isPlayerMove: Bool) {
//        self.points = points
//        self.ignorePoints = ignorePoints
//        self.start = start
//        
//        self.startPoint = startPoint
//        self.isPlayerMove = isPlayerMove
//    }
//    
//
//    // make route animatable head position only
//    var animatableData: AnimatablePair<CGFloat, CGFloat> {
//        get { AnimatablePair(startPoint.x, startPoint.y) }
//        set {
//            startPoint.x = newValue.first
//            startPoint.y = newValue.second
//            
//        }
//    }
//
//    func path(in rect: CGRect) -> Path {
//        Path { path in
//            guard points.count >= 1 else { return }
//            guard (Int(start.x) != 0 && Int(start.y) != 0) else { return}
//            path.move(to: start)
//            
//            for i in 0..<points.dropLast().count {
//                path.addLine(to: points[i])
//                if i < ignorePoints.count {
//                    path.move(to: ignorePoints[i])
//                }
//                
//                
//            }
//
//            
//            if !self.isPlayerMove {
//                path.addLine(to: points[points.count - 1])
//                path.move(to: startPoint)
//            }
//            else {
//                path.addLine(to: startPoint)
//            }
//        }
//    }
//}
class RouteVM: ObservableObject {
    var points: [[CGPoint]] = []
    var ignorePoints: [CGPoint] = []
    @Published var startPoint: CGPoint = CGPoint(x: 0, y: 0)
}
