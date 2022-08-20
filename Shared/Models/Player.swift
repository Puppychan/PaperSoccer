//
//  Player.swift
//  PlayNow
//
//  Created by Nhung Tran on 17/08/2022.
//

import Foundation

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
