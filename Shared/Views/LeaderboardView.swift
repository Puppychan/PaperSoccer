//
//  LeaderboardView.swift
//  PlayNow
//
//  Created by Nhung Tran on 18/08/2022.
//

import SwiftUI

struct LeaderboardView: View {
    @EnvironmentObject var model: GameModel
    var body: some View {
        GeometryReader { geo in
            LazyVStack {
                ForEach(0..<model.players.count, id: \.self) { index in
                    HStack {
                        // MARK: Leaderboard position
                        ZStack {
                            Circle()
                                .fill(.gray)
                                .frame(width: geo.size.width / 6)
                            Text("\(index)")
                                .foregroundColor(.white)

                        }
                        
                        // MARK: Leaderboard username
                        Text(model.players[index].username)
                        
                        Spacer()
                        
                        // MARK: Score
                        Text("\(model.players[index].totalScore)")
                    }
                }
            }
        }
        .onAppear() {
            model.sortPlayerInScore()
        }
    }
}

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView()
            .environmentObject(GameModel())
    }
}
