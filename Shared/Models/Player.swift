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

 */

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
