//
//  ModalView.swift
//  PlayNow
//
//  Created by Nhung Tran on 18/08/2022.
//
// https://stackoverflow.com/questions/58983538/how-to-optionally-pass-in-a-binding-in-swiftui
// https://stackoverflow.com/questions/61920405/programatic-navigation-for-navigationview-using-tag-selection-or-isactive

import SwiftUI


struct ResultModalView: View {
    @EnvironmentObject var model: GameModel
    @Binding var isShowModal: Bool
    @Binding var showingSubview: Bool
    
    var width: CGFloat
    var height: CGFloat
    
    private var title: String
    private var message: String
    private var buttonTitle: String
    
    private var type: WinningType
    
    // MARK: init modal contents based on type modal
    init(type: WinningType, width: CGFloat, height: CGFloat, isShowModal: Binding<Bool>, showingSubview: Binding<Bool>) {
        self.type = type
        switch self.type {
        case .humanWin:
            // human win
            (self.title, self.message, self.buttonTitle) = ("You Win!", "Continue Game?", "Continue the game")
        case .computerWin:
            // human lost
            (self.title, self.message, self.buttonTitle) = ("You Lost", "Continue Game?", "Try Again")
        default:
            // draw
            (self.title, self.message, self.buttonTitle) = ("Draw", "Continue Game?", "Try Again")
            
        }
        self.width = width
        self.height = height
        
        // init binding
        self._isShowModal = isShowModal
        self._showingSubview = showingSubview
    }
    
    var body: some View {
        
        let buttonHeight = height / 6.3
        
        ZStack {
            Rectangle()
                .foregroundColor(Color("Result BckClr"))
                .modifier(modalStyle())
            VStack(spacing: 15) {
                Spacer()
                // MARK: modal content
                VStack {
                    Text(self.title)
                        .font(.largeTitle)
                    Text(self.message)
                        .font(.subheadline)
                }
                .foregroundColor(Color("Result TxtClr"))
                Spacer()
                
                // MARK: continue to play button
                Button(action: {
                    // sound
                    SoundModel.startBackgroundMusic(bckName: "game", type: "mp3")
                    SoundModel.stopSoundEffect()
                    
                    // close the modal
                    isShowModal.toggle()
                    
                    // reset game function here
                    print("Press Continue")
                    
                }, label: {
                    RectangleButtonView(bckColor: Color("Result TxtClr"), txtColor: Color("Result BckClr"), txt: self.buttonTitle, height: buttonHeight)
                })
                
                // MARK: exit game button
                Button(action: {
                    // update current scores
                    model.updateScores(winStatus: self.type)
                    
                    model.exitGame()
                    
                    // back to main menu here
                    showingSubview = false
                }, label: {
                    RectangleButtonView(bckColor: .white, txtColor: .black, txt: "Exit Game", height: buttonHeight)
                })
                
            }
            .modifier(modalPadding())
        }
        .frame(width: self.width, height: self.height)
    }
}
