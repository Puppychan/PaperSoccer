//
//  MenuView.swift
//  PlayNow
//
//  Created by Nhung Tran on 17/08/2022.
//

import SwiftUI

struct MenuView: View {
    @EnvironmentObject var model: GameModel
    enum NavigationDestination: Int {
        case play
        case leader
        case instruction
    }
    var body: some View {

        GeometryReader { geometry in
            ZStack {
                HStack {
                    Spacer()
                    NavigationView {
                        VStack(alignment: .center) {
                            Spacer()
                            // MARK: hello current user
                            VStack {
                                HStack {
                                    Text("Hello")
                                    Spacer()
                                }
                                HStack {
                                    Spacer()
                                    Text(model.currentHuman.username)
                                }
                            }
                                .frame(width: geometry.size.width / 3.6)


                            // MARK: play game button
                            NavigationLink(
                                tag: NavigationDestination.play.rawValue,
                                selection: $model.backToHome,
                                destination: {
                                    GameView()
                                },
                                label: {
                                    Text("Play Game")
                                })

                            // MARK: Leaderboard views
                            NavigationLink(
                                tag: NavigationDestination.leader.rawValue,
                                selection: $model.backToHome,
                                destination: {
                                    LeaderboardView()
                                },
                                label: {
                                    Text("Leaderboard")
                                })

                            // MARK: instruction




                        }
                    }
                    Spacer()
                }
            }
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
            .environmentObject(GameModel())
    }
}
