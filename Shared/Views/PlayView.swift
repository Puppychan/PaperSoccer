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
 https://stackoverflow.com/questions/58721384/big-unwanted-space-in-subview-navigation-bar
 */

import SwiftUI

struct PlayView: View {
    
    
    @EnvironmentObject var model: GameModel
    @State private var isShowModal = false
    @State var humanWinStatus: WinningType = .none
    @Binding var showingSubview: Bool
    @Binding var difficulty: String
    
    @State var usernameSize: CGFloat = 0.0
    @State var scoreSize: CGFloat = 0.0
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // MARK: background
                ImageBackground(name: "game-view-bck", opacity: 0.7, brightness: -0.05)
                VStack {
                    
                    HStack {
                        // MARK: back button
                        BackButton(showingSubview: $showingSubview, width: geo.size.width / 7, height: geo.size.width / 7)
                        
                        // MARK: bot score
                        Spacer()
                        HStack {
                            PlayerNameView(username: model.currentBot.username, score: model.currentBot.currentScore, usernameSize: usernameSize, scoreSize: scoreSize)
                            PlayerIconView(nameImage: "bot", geo: geo)
                        }
                    }
                    
                    Spacer()
                    
                    // MARK: game
                    GameView(winStatus: $humanWinStatus, showModal: $isShowModal, playMode: $difficulty, screenWidth: geo.size.width / 1.1, screenHeight: geo.size.height / 1.1)
                        .frame(width: geo.size.width / 1.1, height: geo.size.height / 2, alignment: .center)
                    
                    
                    Spacer()
                    
                    // MARK: human score
                    HStack {
                        HStack {
                            PlayerIconView(nameImage: "human", geo: geo)
                            // if add username feature, modify here
                            PlayerNameView(username: model.currentHuman.username, score: model.currentHuman.currentScore, usernameSize: usernameSize, scoreSize: scoreSize)
                        }
                        Spacer()
                    }
                    
                }
                .padding()
                .modifier(opacityModalOpen(isShowModal: isShowModal))
                
                // MARK: - Modal window
                if isShowModal {
                    let width = geo.size.width / 1.3
                    let height = geo.size.height / 2.5
                    ResultModalView(type: humanWinStatus, width: width, height: height, isShowModal: $isShowModal, showingSubview: $showingSubview)
                    
                }
            }
            .onAppear() {
                // init username text display size and icon display size
                usernameSize = geo.size.width / 16
                scoreSize = geo.size.width / 14
            }
            
        }
        
        
    }
}
