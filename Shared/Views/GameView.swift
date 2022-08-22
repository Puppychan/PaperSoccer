//
//  GameView.swift
//  PlayNow
//
//  Created by Nhung Tran on 17/08/2022.
//
//custom toolbar: https://stackoverflow.com/questions/58721384/big-unwanted-space-in-subview-navigation-bar

import SwiftUI

struct GameView: View {
    @EnvironmentObject var model: GameModel
    @State private var isShowModal = false
    @State var humanWinStatus: WinningType = .humanWin
    
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
                // MARK: - main game view
                VStack {

                    // MARK: bot score
                    HStack {
                        Spacer()
                        PlayerNameView(username: model.currentBot.username, score: model.currentBot.currentScore)
                        PlayerIconView(nameImage: "bot", geo: geo)
                    }

                    Spacer()

                    // MARK: game
//                    LazyVStack {
//                        HStack {
//                            Button(action: {
//                                model.currentBot.currentScore += 1
//                            }, label: { Text("Bot") })
//                            Button(action: {
//                                model.currentHuman.currentScore += 1
//                            }, label: { Text("Human") })
//                        }
//                        Button(action: {
//                            humanWinStatus = model.checkInMatchWin()
//                            isShowModal.toggle()
//
//                        }, label: {
//                            RectangleButtonView(bckColor: .black, txtColor: .white, txt: "Submit", height: geo.size.height / 8)
//                        })
//                    }
                    GameContentView(winStatus: $humanWinStatus, showModal: $isShowModal, parentGeo: geo)
                        .environmentObject(GameContentModel())
                        

                    Spacer()

                    // MARK: human score
                    HStack {
                        PlayerIconView(nameImage: "human", geo: geo)
                        // if add username feature, modify here
                        PlayerNameView(username: model.currentHuman.username, score: model.currentHuman.currentScore)
                        Spacer()
                    }

                }
    //            .toolbar(content: {
    //                ToolbarItem(placement: .navigationBarLeading) {
    //                    backButton
    //                }
    //            })
                .navigationBarTitle("", displayMode: .inline)
                .opacity(isShowModal ? 0.3 : 1)
                .brightness(isShowModal ? -0.5 : 0)
                
                // MARK: - Modal window
                if isShowModal {
                    let width = geo.size.width / 1.3
                    let height = geo.size.height / 2.5
                    ModalView(type: humanWinStatus, width: width, height: height, isShowModal: $isShowModal)
                    
                }
            }

        }


    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .environmentObject(GameModel())
    }
}
