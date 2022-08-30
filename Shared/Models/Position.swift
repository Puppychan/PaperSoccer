/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2022B
 Assessment: Assignment 2
 Author: Tran Mai Nhung
 ID: s3879954
 Created  date: 15/08/2022
 Last modified: 29/08/2022
 Acknowledgement: Tom Huynh github, canvas
 // https://stackoverflow.com/questions/30105272/compare-two-instances-of-an-object-in-swift
 // https://stackoverflow.com/questions/61648927/swift-5-making-a-class-hashable
 */


import Foundation

struct Position: Equatable, Hashable {
    var row, col: Int
    // init
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
    
    
    // MARK: hashing
    func hash(into hasher: inout Hasher) {
        hasher.combine(row)
    }
    static func == (lhs: Position, rhs: Position) -> Bool {
        return lhs.row == rhs.row && lhs.col == rhs.col
    }

}
