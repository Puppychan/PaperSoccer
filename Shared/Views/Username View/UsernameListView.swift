//
//  UsernameListView.swift
//  PaperSoccer
//
//  Created by Nhung Tran on 28/08/2022.
//

import SwiftUI

struct UsernameListView: View {
    @EnvironmentObject var model: GameModel
    
    @State private var isCreatingName = false
    @State private var username: String = ""
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.white) // temp
                .modifier(modalStyle())
            
            VStack {
                // MARK: close button
                HStack {
                    Spacer()
//                    Button(action: {
//                        // close modal
//                        isShowChangeUsername.toggle()
//                    }, label: {
//                        Image(systemName: "x.circle")
//                    })
                }
                HStack {
                    Text("Players".uppercased())
                        .font(.largeTitle)
                    Spacer()
                    Button(action: {
                        isCreatingName.toggle()
                    }, label: {
                        Image(systemName: "plus.circle")
                    })
                }
                
                // MARK: create name field
                if isCreatingName {
                    HStack {
                        TextField("Enter username...", text: $username)
    //                        .frame(width: 300)
                                                .font(.title2)
                                                .scaledToFit()
                                                .cornerRadius(12)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .onSubmit {
                                    if !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                        model.addUser(newUsername: username)
                                        username = ""
                                    }
                                }
                    }
                }
                
                // MARK: list users
                ScrollView {
                    LazyVStack {
                        ForEach(model.players.filter({ $0.isHuman
                        })) { (user) in
                            
                            Label(user.username, systemImage: "person.fill")
                                .onTapGesture(perform: {
                                    model.switchUser(for: user.id)
                                })
                        }
                    }
                }
            }
            
        }
    }
}
