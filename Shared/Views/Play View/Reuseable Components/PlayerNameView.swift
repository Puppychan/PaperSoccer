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
    
    var body: some View {
        HStack {
            Text(username)
                .font(.custom("Roboto-Regular", size: 20))
            Text("\(score)")
                .font(.custom("Roboto-Bold", size: 25))
        }
    }
}
