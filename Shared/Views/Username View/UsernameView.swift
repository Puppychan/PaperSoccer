//
//  UsernameView.swift
//  PaperSoccer
//
//  Created by Nhung Tran on 28/08/2022.
//

import SwiftUI

struct UsernameView: View {
    @EnvironmentObject var model: GameModel
    @Binding var isShowChangeUsername: Bool
    var body: some View {
        ZStack {
            // MARK: display welcome message with username
            HStack {
                Text("Hello".uppercased())
                
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
