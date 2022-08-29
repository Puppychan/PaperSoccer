//
//  DifficultiesModal.swift
//  PaperSoccer
//
//  Created by Nhung Tran on 29/08/2022.
//

import SwiftUI

struct DifficultiesModal: View {
    @Binding var difficulty: String
    @Binding var isShowDiffiModes: Bool
    var width: CGFloat
    var height: CGFloat
    var showFunc: (_ withIndex: Int) -> Void

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
        let buttonHeight = height / 6
        let buttons = ["easy", "normal", "hard"]


        ZStack {
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
