//
//  Move.swift
//  PaperSoccer
//
//  Created by Nhung Tran on 22/08/2022.
// https://stackoverflow.com/questions/30105272/compare-two-instances-of-an-object-in-swift

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
struct TempMove {
    var position: Position
    var scores: Int
}
struct TempPosition {
    var isBot: Bool
    var occupyDirection: [Position]
}

struct Position: Equatable {
    var row, col: Int
    init(_ row: Int, _ col: Int) {
        self.row = row
        self.col = col
    }
    
    func equals(_ comparePosition: Position) -> Bool {
        return self.row == comparePosition.row &&
        self.col == comparePosition.col
    }
}
