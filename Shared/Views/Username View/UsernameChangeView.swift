//
//  UsernameChangeView.swift
//  PaperSoccer
//
//  Created by Nhung Tran on 28/08/2022.
//

import SwiftUI

struct UsernameChangeView: View {
    @EnvironmentObject var model: GameModel
    
    @Binding var isShowChangeUsername: Bool
    
    var width: CGFloat
    var height: CGFloat
    var buttonHeight: CGFloat
    
    @State var username: String = ""
//    func validateUsername(username: String) -> Bool {
//        if
//    }
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white)
                .modifier(modalStyle())
            VStack {
                // MARK: close button
                HStack {
                    Spacer()
                    Button(action: {
                        // close modal
                        isShowChangeUsername.toggle()
                    }, label: {
                        Image(systemName: "x.circle")
                    })
                }
                // MARK: input here
                TextField("Enter username...", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                
                // MARK: submit button
                Button(action: {
                    
                    // update change
                    model.updateUsername(newUsername: username)
                    
                    // close modal
                    isShowChangeUsername.toggle()
                }, label: {
                    RectangleButtonView(bckColor: .black, txtColor: .white, fontName: "Roboto-Black", cornerRadius: Constants.cornerRadius, txt: "Submit".uppercased(), height: buttonHeight)
                })
                .disabled(username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) // validate
            }
            .padding(.horizontal, Constants.horizontalPadding)
            .padding(.vertical, Constants.verticalPadding + 10)
        }
        
        .frame(width: width, height: height)
        
    }
}
