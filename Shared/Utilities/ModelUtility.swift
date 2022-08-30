/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 2
  Author: Tran Mai Nhung
  ID: s3879954
  Created  date: 15/08/2022
  Last modified: 29/08/2022
  Acknowledgement: Tom Huynh github, canvas // https://stackoverflow.com/questions/26845307/generate-random-alphanumeric-string-in-swift
 // https://stackoverflow.com/questions/57467353/conditional-property-in-swiftui
 // https://stackoverflow.com/questions/71095953/add-filled-circles-markers-at-swiftui-path-points
*/


import Foundation
import SwiftUI

struct ModelUtility {
    static let angleDrag: CGFloat = 20
    
    // MARK: - username
    // random username generate
    static func randomUsername() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<Int.random(in: 3...7)).map { _ in letters.randomElement()! })
    }

    // MARK: - find drag direction
    
    // MARK: find direction in horizontal or vertical only
    static func findDragDirectionOnCoordinate(startCoordinate: CGFloat,
        currentCoordinate: CGFloat,
        isHorizontal: Bool) -> String {
        // for north, east, west, south drag easier
        if abs(startCoordinate - currentCoordinate) <= angleDrag {
            // equal
            return "none"
        } else if startCoordinate > currentCoordinate {
            // left or top
            return isHorizontal ? "left" : "top"
        } else {
            // right or bottom
            return isHorizontal ? "right" : "bottom"
        }
    }
    
    // MARK: find final drag direction
    static func findDragDirection(startLocation: CGPoint, location: CGPoint) -> DragDirection {
        let verticalDirection = findDragDirectionOnCoordinate(startCoordinate: startLocation.y, currentCoordinate: location.y, isHorizontal: false)
        let horizontalDirection = findDragDirectionOnCoordinate(startCoordinate: startLocation.x, currentCoordinate: location.x, isHorizontal: true)
        return DragDirection(rawValue: "\(verticalDirection) \(horizontalDirection)") ?? .none
    }

    // MARK: - drawing path
    // MARK: move to current position
    static func moveCurrentPath(on path: inout Path, _ destination: CGPoint, currentPosition: inout CGPoint) {
        path.move(to: destination)
        ModelUtility.drawCircle(point: destination, on: &path)
        currentPosition = destination
    }
    
    // MARK: drawing path
    static func drawMovingLine(on path: inout Path, _ destination: CGPoint, currentPosition: inout CGPoint) {
        path.addLine(to: destination)
        ModelUtility.drawCircle(point: destination, on: &path)
        currentPosition = destination
    }
    
    // MARK: draw circle annotation
    static func drawCircle(point: CGPoint, on path: inout Path) {
        let dotRadius: CGFloat = 5.0
        path.addEllipse(in: CGRect(x: point.x - dotRadius * 0.5, y: point.y - dotRadius * 0.5, width: dotRadius, height: dotRadius))
    }

}
