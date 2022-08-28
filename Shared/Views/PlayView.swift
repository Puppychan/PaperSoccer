//
//  GameView.swift
//  PlayNow
//
//  Created by Nhung Tran on 17/08/2022.
//
//custom toolbar: https://stackoverflow.com/questions/58721384/big-unwanted-space-in-subview-navigation-bar

import SwiftUI

struct PlayView: View {
    
    
    @EnvironmentObject var model: GameModel
    @State private var isShowModal = false
    @State var humanWinStatus: WinningType = .none
    @Binding var showingSubview: Bool
    
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
//
//    var backButton: some View {
//
//        Button(action: {
//            self.presentationMode.wrappedValue.dismiss()
//        }, label: {
//            HStack {
//                Image(systemName: "chevron.left")
//                Text("Back") // 2
//            }
//        })
//    }
    

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
                            PlayerNameView(username: model.currentBot.username, score: model.currentBot.currentScore)
                            PlayerIconView(nameImage: "bot", geo: geo)
                        }
                    }

                    Spacer()

                    // MARK: game
                    GameView(winStatus: $humanWinStatus, showModal: $isShowModal, screenWidth: geo.size.width / 1.1, screenHeight: geo.size.height / 1.1)
                        .frame(width: geo.size.width / 1.1, height: geo.size.height / 2, alignment: .center)
                        .environmentObject(GameContentModel())
                        

                    Spacer()

                    // MARK: human score
                    HStack {
                        HStack {
                            PlayerIconView(nameImage: "human", geo: geo)
                            // if add username feature, modify here
                            PlayerNameView(username: model.currentHuman.username, score: model.currentHuman.currentScore)
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

        }


    }
}
struct PlayView_Previews: PreviewProvider {
    @State var showingSubview = false
    static var previews: some View {
        PlayView(showingSubview: .constant(true))
            .environmentObject(GameModel())
    }
}
