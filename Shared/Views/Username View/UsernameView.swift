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

struct UsernameView: View {
    @EnvironmentObject var model: GameModel
    @Binding var isShowChangeUsername: Bool
    var body: some View {
        ZStack {
            // MARK: display welcome message with username
            HStack {
                Text("Hello".uppercased())
                
                // MARK: click to change default username
                Button(action: {
                    // open the modal
                    isShowChangeUsername.toggle()
                    
                }, label: {
                    Text(model.currentHuman.username)
                        .font(.title)
                        .italic()
                        .underline()
                    Image(systemName: "square.and.pencil")
                })
            }
            .foregroundColor(Color("Username TxtClr"))
            .font(.title2)
            
        }
    }
}
