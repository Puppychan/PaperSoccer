//
//  Player.swift
//  PlayNow
//
//  Created by Nhung Tran on 17/08/2022.
//

import Foundation
enum WinningType: String {
    case humanWin = "human win"
    case computerWin = "computer win"
    case draw = "draw"
}
struct Player: Identifiable {
    let id: UUID = UUID()
    var username: String
    var isHuman: Bool
    var currentScore: Int
    var totalScore: Int
    
    func testData() -> Player {
        return Player(username: "Matsuri", isHuman: true, currentScore: 0, totalScore: 0)
    }
}
