//
//  Move.swift
//  PaperSoccer
//
//  Created by Nhung Tran on 22/08/2022.
// https://stackoverflow.com/questions/30105272/compare-two-instances-of-an-object-in-swift
// https://stackoverflow.com/questions/61648927/swift-5-making-a-class-hashable

import Foundation
struct Move {
    var currentIsBot: Bool
    let isOccupy: Bool
    // store index of related direction
    //    var occupyDirection: [Int]
    var occupyDirection: [Position]
    
    var scores: Int
    var position: Position
}

struct Position: Equatable, Hashable {
    var row, col: Int
    init(_ row: Int, _ col: Int) {
        self.row = row
        self.col = col
    }
    
    // MARK: check if 2 equals
    func equals(_ comparePosition: Position) -> Bool {
        return self.row == comparePosition.row &&
        self.col == comparePosition.col
    }
    
    // MARK: validate new index based on direction
    func isMovingEast(new newPosition: Position) -> Bool {
        return (self.row == newPosition.row && self.col + 1 == newPosition.col)
    }
    func isMovingWest(new newPosition: Position) -> Bool {
        return self.row == newPosition.row && self.col - 1 == newPosition.col
    }
    func isMovingNorth(new newPosition: Position) -> Bool {
        return self.row - 1 == newPosition.row && self.col == newPosition.col
    }
    func isMovingSouth(new newPosition: Position) -> Bool {
        return self.row + 1 == newPosition.row && self.col == newPosition.col
    }
    func isMovingNorthEast(new newPosition: Position) -> Bool {
        return self.row - 1 == newPosition.row && self.col + 1 == newPosition.col
    }
    func isMovingNorthWest(new newPosition: Position) -> Bool {
        return self.row - 1 == newPosition.row && self.col - 1 == newPosition.col
    }
    func isMovingSouthWest(new newPosition: Position) -> Bool {
        return self.row + 1 == newPosition.row && self.col - 1 == newPosition.col
    }
    func isMovingSouthEast(new newPosition: Position) -> Bool {
        return self.row + 1 == newPosition.row && self.col + 1 == newPosition.col
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(row)
    }
    static func == (lhs: Position, rhs: Position) -> Bool {
        return lhs.row == rhs.row && lhs.col == rhs.col
    }

}
