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

struct UsernameChangeView: View {
    @EnvironmentObject var model: GameModel
    
    @Binding var isShowChangeUsername: Bool
    
    var width: CGFloat
    var height: CGFloat
    var buttonHeight: CGFloat
    
    @State var username: String = ""
    
    var body: some View {
        ZStack {
            // MARK: background or container of the modal view
            Rectangle()
                .foregroundColor(Color("Username Modal BckClr"))
                .modifier(modalStyle())
            
            // MARK: content of changing view modal
            VStack(alignment: .leading) {
                // MARK: close button
                HStack {
                    Spacer()
                    // close button
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
