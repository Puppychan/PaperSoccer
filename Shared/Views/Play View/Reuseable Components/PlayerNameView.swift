//
//  PlayerNameView.swift
//  PlayNow
//
//  Created by Nhung Tran on 18/08/2022.
//

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
