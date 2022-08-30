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

struct UsernameListView: View {
    @EnvironmentObject var model: GameModel
    
    @State private var isCreatingName = false
    @State private var username: String = ""
    @Binding var showingSubview: Bool
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // MARK: background image
                ImageBackground(name: "username-bck")
                    .brightness(-0.55)
                    .opacity(0.3)
                    .grayscale(0.5)
                    .background(Color("Username List BckClr"))
                
                VStack(alignment: .leading, spacing: geo.size.width / 15) {
                    
                    HStack {
                        // MARK: close button
                        BackButton(showingSubview: $showingSubview, width: geo.size.width / 8.5, height: geo.size.width / 8.5)
                        Spacer()
                        
                        // MARK: plus button
                        Button(action: {
                            isCreatingName.toggle()
                        }, label: {
                            Image(systemName: "plus.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geo.size.width / 13)
                                .foregroundColor(Color("Username List SpecialClr"))
                        })
                        .buttonStyle(.plain)
                    }
                    // MARK: display welcome message into this view
                    VStack(alignment: .leading, spacing: geo.size.width / 40) {
                        HStack {
                            Text("Hi")
                            Text(" \(model.currentHuman.username)")
                                .foregroundColor(Color("Username List SpecialClr"))
                        }
                        
                        Text("You want to switch to...")
                        
                    }
                    .font(.custom("Roboto-MediumItalic", size: geo.size.width / 13))
                    .foregroundColor(Color("Username List TxtClr"))
                    
                    
                    // MARK: create name field
                    if isCreatingName {
                        HStack {
                            TextField("Enter username...", text: $username)
                                .font(.title2)
                                .scaledToFit()
                                .cornerRadius(12)
                                .textFieldStyle(CustomTextFieldStyle(width: geo.size.width / 3))
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
                        LazyVStack(alignment: .leading, spacing: geo.size.width / 25) {
                            ForEach(model.players.filter({ $0.isHuman
                            })) { (user) in
                                
                                // tap to switch user
                                Label(user.username, systemImage: "person.fill")
                                    .onTapGesture(perform: {
                                        model.switchUser(for: user.id)
                                    })
                                    .font(.custom("Roboto-Light", size: geo.size.width / 17))
                                    .foregroundColor(Color("Username List TxtClr"))
                            }
                        }
                    }
                }
                .frame(width: geo.size.width / 1.16, height: geo.size.height)
                
            }
        }
    }
}
