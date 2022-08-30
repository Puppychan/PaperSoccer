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
struct Move {
    var currentIsBot: Bool
    let isOccupy: Bool
    // store index of related direction
    var occupyDirection: [Position]
    
    var scores: Int
    var position: Position
}


