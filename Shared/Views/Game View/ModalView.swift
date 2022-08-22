//
//  ModalView.swift
//  PlayNow
//
//  Created by Nhung Tran on 18/08/2022.
//
// https://stackoverflow.com/questions/58983538/how-to-optionally-pass-in-a-binding-in-swiftui
// https://stackoverflow.com/questions/61920405/programatic-navigation-for-navigationview-using-tag-selection-or-isactive

import SwiftUI


struct ModalView: View {
    @EnvironmentObject var model: GameModel
    @Binding var isShowModal: Bool
    
    var width: CGFloat
    var height: CGFloat

    private var title: String
    private var message: String
    private var buttonTitle: String
    
    private var type: WinningType

    // MARK: init modal contents based on type modal
    init(type: WinningType, width: CGFloat, height: CGFloat, isShowModal: Binding<Bool>) {
        self.type = type
        switch self.type {
        case .humanWin:
            // human win
            (self.title, self.message, self.buttonTitle) = ("Human Win", "You beat the AI", "Continue the game")
        case .computerWin:
            // human lost
            (self.title, self.message, self.buttonTitle) = ("You Lost", "Your AI is super smart", "Try Again")
        default:
            // draw
            (self.title, self.message, self.buttonTitle) = ("Draw", "What a battle of wits we have here...", "Try Again")

        }
        self.width = width
        self.height = height
        
        // init binding
        self._isShowModal = isShowModal
    }

    var body: some View {
        
        let buttonHeight = height / 6.3
        
        ZStack {
            Rectangle()
                .foregroundColor(.white) // temporary
            .cornerRadius(Constants.cornerRadius)
                .shadow(color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.5), radius: 10, x: -5, y: 5)
            VStack(spacing: 15) {
                Spacer()
                // MARK: modal content
                VStack {
                    Text(self.title)
                        .font(.largeTitle)
                    Text(self.message)
                        .font(.subheadline)
                }
                Spacer()

                // MARK: continue to play button
                Button(action: {
                    // update current scores
                    model.updateScores(winStatus: self.type)
                    
                    // close the modal
                    isShowModal.toggle()

                    // reset game function here
                    print("Press Continue")
                    
                }, label: {
                    RectangleButtonView(bckColor: .green, txtColor: .white, txt: self.buttonTitle, height: buttonHeight)
                })

                // MARK: exit game button
                Button(action: {
                    // update current scores
                    model.updateScores(winStatus: self.type)
                    
                    // exit game and update total scores of players
                    model.updateWinNumber()
                    
                    // back to main menu here
                    model.backToHome = nil
                    
                    
                }, label: {
                    RectangleButtonView(bckColor: .black, txtColor: .white, txt: "Exit Game", height: buttonHeight)
                })

            }
                .padding(.horizontal, Constants.horizontalPadding)
                .padding(.vertical, Constants.verticalPadding + 10)
        }
            .frame(width: self.width, height: self.height)
    }
}
