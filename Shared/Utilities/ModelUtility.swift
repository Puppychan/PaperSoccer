//
//  ViewUltility.swift
//  PlayNow
//
//  Created by Nhung Tran on 18/08/2022.
// https://stackoverflow.com/questions/57467353/conditional-property-in-swiftui
// https://stackoverflow.com/questions/71095953/add-filled-circles-markers-at-swiftui-path-points

import Foundation
import SwiftUI

struct ModelUtility {
    static let angleDrag: CGFloat = 20
    static func randomUsername() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<Int.random(in: 3...7)).map { _ in letters.randomElement()! })
    }

    // MARK: - find drag direction
    // MARK: find direction in horizontal or vertical only
    static func findDragDirectionOnCoordinate(startCoordinate: CGFloat,
        currentCoordinate: CGFloat,
        isHorizontal: Bool) -> String {
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

    static func findDragDirection(startLocation: CGPoint, location: CGPoint) -> DragDirection {
        let verticalDirection = findDragDirectionOnCoordinate(startCoordinate: startLocation.y, currentCoordinate: location.y, isHorizontal: false)
        let horizontalDirection = findDragDirectionOnCoordinate(startCoordinate: startLocation.x, currentCoordinate: location.x, isHorizontal: true)
        return DragDirection(rawValue: "\(verticalDirection) \(horizontalDirection)") ?? .none
    }

    // MARK: - drawing path
    static func moveCurrentPath(on path: inout Path, _ destination: CGPoint, currentPosition: inout CGPoint) {
        path.move(to: destination)
        ModelUtility.drawCircle(point: destination, on: &path)
        currentPosition = destination
    }
    static func drawMovingLine(on path: inout Path, _ destination: CGPoint, currentPosition: inout CGPoint) {
        path.addLine(to: destination)
        ModelUtility.drawCircle(point: destination, on: &path)
        currentPosition = destination
    }
//    static func draw(point: CGPoint, on path: inout Path) {
    static func drawCircle(point: CGPoint, on path: inout Path) {
        let dotRadius: CGFloat = 5.0
//        path.addLine(to: CGPoint(x: point.x, y: point.y))
        path.addEllipse(in: CGRect(x: point.x - dotRadius * 0.5, y: point.y - dotRadius * 0.5, width: dotRadius, height: dotRadius))
    }

}
