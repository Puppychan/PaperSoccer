//
//  GameShape.swift
//  PaperSoccer (iOS)
//
//  Created by Nhung Tran on 28/08/2022.
//
// https://www.hackingwithswift.com/books/ios-swiftui/creating-custom-paths-with-swiftui
// https://www.youtube.com/watch?v=YSBXJvANWSo&t=304s

import SwiftUI

// MARK: draw whole stadium
struct StadiumSquares: Shape {
    var offsetX: CGFloat
    var offsetY: CGFloat
    let model: GameContentModel
    var isEvenSquare: Bool
    
    var spacingGrid: CGFloat
    var circleSize: CGFloat
    var isHumanPlace: Bool
    

    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = spacingGrid + circleSize
        let height = width
        let startRow: Int
        let endRow: Int
        
        if isHumanPlace {
            startRow = model.totalRows / 2
            endRow = model.totalRows
        }
        else {
            startRow = 0
            endRow = (model.totalRows / 2) + 1
        }
        
        for row in startRow..<endRow - 1 {
            for col in 0..<model.totalColumns - 1 {
                if !model.isIgnorePosition(forRow: row, forCol: col) &&
                    !model.isIgnorePosition(forRow: row + 1, forCol: col + 1) &&
                    !model.isIgnorePosition(forRow: row, forCol: col + 1) &&
                    !model.isIgnorePosition(forRow: row + 1, forCol: col) {
                    if (isEvenSquare && (row + col).isMultiple(of: 2)) ||
                        (!isEvenSquare && !(row + col).isMultiple(of: 2)) {
                        let startX = offsetX + Double(col) * width
                        let startY = offsetY + Double(row) * height
                        
                        let rect = CGRect(x: startX, y: startY, width: width, height: height)
                        path.addRect(rect)
                    }
                    
                }
            }
        }
        
        return path
    }
}

// - MARK: drawing border shape
struct StadiumBorder: Shape {
    var offsetY: CGFloat
    var offsetX: CGFloat
    var circleSize: CGFloat
    var spacingGrid: CGFloat
    var columns: Int
    var rows: Int

    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let smallDistance = circleSize + spacingGrid
        path.move(to: CGPoint(x: offsetX, y: offsetY + smallDistance))

        path.addLine(to: CGPoint(x: offsetX, y: offsetY + smallDistance * CGFloat((rows - 2))))
        path.addLine(to: CGPoint(x: offsetX + smallDistance * CGFloat(((columns / 2) - 1)), y: offsetY + smallDistance * CGFloat((rows - 2))))
        // horizontal
        path.addLine(to: CGPoint(x: offsetX + smallDistance * CGFloat(((columns / 2) - 1)), y: offsetY + smallDistance * CGFloat((rows - 1))))
        path.addLine(to: CGPoint(x: offsetX + smallDistance * CGFloat(((columns / 2) + 1)), y: offsetY + smallDistance * CGFloat((rows - 1))))
        path.addLine(to: CGPoint(x: offsetX + smallDistance * CGFloat(((columns / 2) + 1)), y: offsetY + smallDistance * CGFloat((rows - 2))))
        path.addLine(to: CGPoint(x: offsetX + smallDistance * CGFloat(columns - 1), y: offsetY + smallDistance * CGFloat((rows - 2))))
        path.addLine(to: CGPoint(x: offsetX + smallDistance * CGFloat(columns - 1), y: offsetY + smallDistance))
        path.addLine(to: CGPoint(x: offsetX + smallDistance * CGFloat((columns / 2) + 1), y: offsetY + smallDistance))
        path.addLine(to: CGPoint(x: offsetX + smallDistance * CGFloat((columns / 2) + 1), y: offsetY))
        path.addLine(to: CGPoint(x: offsetX + smallDistance * CGFloat((columns / 2) - 1), y: offsetY))
        path.addLine(to: CGPoint(x: offsetX + smallDistance * CGFloat((columns / 2) - 1), y: offsetY + smallDistance))
        path.addLine(to: CGPoint(x: offsetX, y: offsetY + smallDistance))
        path.closeSubpath()
        return path
    }
}
