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
// display difficult options for user to choose before playing game
struct DifficultiesModal: View {
    @Binding var difficulty: String
    @Binding var isShowDiffiModes: Bool
    var width: CGFloat
    var height: CGFloat
    var showFunc: (_ withIndex: Int) -> Void
    
    // find index of each difficulty
    func findIndexMode(mode: String) -> Int {
        if mode == "easy" {
            return NavigationDestination.playEasy.rawValue
        }
        else if mode == "normal" {
            return NavigationDestination.playNormal.rawValue
        }
        else {
            return NavigationDestination.playHard.rawValue
        }
    }
    var body: some View {
        // init
        let buttonHeight = height / 6
        let buttons = ["easy", "normal", "hard"]
        
        
        ZStack {
            // MARK: background
            Rectangle()
                .foregroundColor(Color("Playmode BckClr"))
                .modifier(modalStyle())
            VStack(spacing: width / 15) {
                
                // MARK: close button
                HStack {
                    Spacer()
                    Button(action: {
                        isShowDiffiModes = false
                    }, label: {
                        Image(systemName: "x.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: width / 12, height: width / 12)
                            .foregroundColor(Color("Playmode SpecialClr"))
                    })
                }
                
                // MARK: mode buttons
                VStack(spacing: width / 16) {
                    ForEach(buttons, id: \.self) { button in
                        Button(action: {
                            difficulty = button
                            showFunc(findIndexMode(mode: button))
                            isShowDiffiModes = false
                            
                            // play background music
                            SoundModel.stopBackgroundMusic()
                            SoundModel.startBackgroundMusic(bckName: "game", type: "mp3")
                        }, label: {
                            RectangleButtonView(bckColor: Color("Playmode Button BckClr"), txtColor: Color("Playmode Button TxtClr"), fontName: "Roboto-Black", cornerRadius: Constants.cornerRadius, txt: button.uppercased(), height: buttonHeight)
                        })
                    }
                }
            }
            .modifier(modalPadding())
            
            
        }
        .frame(width: width, height: height)
    }
}
