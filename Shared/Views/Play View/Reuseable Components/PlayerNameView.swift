/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2022B
 Assessment: Assignment 2
 Author: Tran Mai Nhung
 ID: s3879954
 Created  date: 15/08/2022
 Last modified: 29/08/2022
 Acknowledgement: Canvas, Tom Huynh github

 */

import SwiftUI

struct PlayerNameView: View {
    var username: String
    var score: Int
    var usernameSize: CGFloat
    var scoreSize: CGFloat
    
    var body: some View {
        HStack {
            Text(username)
                .font(.custom("Roboto-Regular", size: usernameSize))
            Text("\(score)")
                .font(.custom("Roboto-Bold", size: scoreSize))
        }
        .foregroundColor(Color("Game Username TxtClr"))
    }
}
