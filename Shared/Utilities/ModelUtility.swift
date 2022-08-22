//
//  ViewUltility.swift
//  PlayNow
//
//  Created by Nhung Tran on 18/08/2022.
// https://stackoverflow.com/questions/57467353/conditional-property-in-swiftui

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

}
