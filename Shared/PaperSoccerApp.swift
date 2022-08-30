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

import SwiftUI
@main
struct PaperSoccerApp: App {
    var body: some Scene {
        WindowGroup {
            MenuView()
                .environmentObject(GameModel())
        }
    }
}
