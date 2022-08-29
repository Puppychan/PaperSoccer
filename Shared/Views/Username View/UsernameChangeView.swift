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
                .foregroundColor(Color("Username Modal BckClr"))
                .modifier(modalStyle())
            VStack(alignment: .leading) {
                // MARK: close button
                HStack {
                    Spacer()
                    Button(action: {
                        // close modal
                        isShowChangeUsername.toggle()
                    }, label: {
                        Image(systemName: "x.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: width / 12)
                            .foregroundColor(Color("Text Field BckClr"))
                    })
                    .buttonStyle(.plain)
                }
                
                // MARK: name modal
                Text("Change Username".uppercased())
                    .font(.title)
                    .foregroundColor(Color("Username Modal TxtClr"))
                
                Spacer()
                
                // MARK: input here
                TextField("Enter Username..", text: $username)
                    .textFieldStyle(CustomTextFieldStyle(width: width / 1.2))
                
                Spacer()
                
                // MARK: submit button
                Button(action: {
                    
                    // update change
                    model.updateUsername(newUsername: username)
                    
                    // close modal
                    isShowChangeUsername.toggle()
                }, label: {
                    RectangleButtonView(bckColor: .white, txtColor: Color("Username Modal BckClr"), fontName: "Roboto-Black", cornerRadius: Constants.cornerRadius, txt: "Submit".uppercased(), height: buttonHeight)
                })
                .disabled(username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) // validate
            }
            .modifier(modalPadding())
        }
        
        .frame(width: width, height: height)
        
    }
}
