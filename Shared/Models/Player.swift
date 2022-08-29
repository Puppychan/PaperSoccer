//
//  Player.swift
//  PlayNow
//
//  Created by Nhung Tran on 17/08/2022.
//

import Foundation

struct Player: Identifiable, Codable {
    var id: UUID = UUID()
    var username: String
    var isHuman: Bool
    var currentScore: Int
    var totalScore: Int
    
    var numGamePlay: Int
    var numWin: Int
    var isReadInstruction: Bool
    
    // store index of badges achieved
    var badges: Set<Int>
}
