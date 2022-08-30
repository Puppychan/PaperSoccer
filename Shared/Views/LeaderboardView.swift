/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 2
  Author: Tran Mai Nhung
  ID: s3879954
  Created  date: 15/08/2022
  Last modified: 29/08/2022
  Acknowledgement: Tom Huynh github, canvas
*/

import SwiftUI

struct LeaderboardView: View {
    @EnvironmentObject var model: GameModel
    @Binding var showingSubview: Bool
    var showFunc: (_ withIndex: Int) -> Void
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // MARK: background image
                ImageBackground(name: "leaderboard-bck")
                    .brightness(-0.3)
                    .opacity(0.6)
                    .background(Color("Leader BckClr"))
                
                VStack(alignment: .center) {
                    // MARK: back home button
                    HStack {
                        
                        BackButton(showingSubview: $showingSubview, width: geo.size.width / 8.5, height: geo.size.width / 8.5)
                        
                        Spacer()
                        Button(action: {
                            showingSubview = false
                            showFunc(NavigationDestination.badge.rawValue)
                        }, label: {
                            Image("achie-trophy")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geo.size.width / 7)
                        })
                        
                    }
                    .padding(.top, geo.size.width / 15)
                    
                    
                    // MARK: title
                    Text("Leaderboard".uppercased())
                        .font(.custom("EASPORTS", size: geo.size.width / 9))
                            .foregroundColor(Color("Leader Title TxtClr"))
                            .tracking(1)
                    
                    // MARK: leaderboard display
                    ScrollView {
                        VStack(alignment: .leading) {
                            
                            ForEach(0..<model.players.count, id: \.self) { index in
                                HStack(spacing: geo.size.width / 15) {
                                    
                                    // MARK: Leaderboard position
                                    // if first 3 leaderboard -> display different icon
                                    if index == 0 {
                                        Image("leaderboard-first")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: geo.size.width / 6)
                                    }
                                    else if index == 1 {
                                        Image("leaderboard-second")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: geo.size.width / 6)
                                    }
                                    else if index == 2 {
                                        Image("leaderboard-third")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: geo.size.width / 6)
                                    }
                                    else {
                                        ZStack {
                                            Circle()
                                                .fill(Color("Leader Medal BckClr"))
                                                .frame(width: geo.size.width / 7, height: geo.size.width / 7)
                                                .opacity(0.8)
                                            Text("\(index + 1)")
                                                .foregroundColor(Color("Leader Medal TxtClr"))
                                                .font(.title)

                                        }
                                        
                                    }
                                    
                                    // MARK: Leaderboard username
                                    Text(model.players[index].username)
                                        .font(.custom("Roboto-Medium", size: geo.size.width / 18))
                                            .foregroundColor(Color("Menu Title TxtClr"))
                                    // MARK: Score
                                    Spacer()
                                    Text("\(model.players[index].totalScore)")
                                        .font(.custom("Roboto-Medium", size: geo.size.width / 17))
                                            .foregroundColor(Color("Menu Title TxtClr"))
                                }
                                .frame(width: geo.size.width / 1.2)
                                
                                // MARK: divider
                                Rectangle()
                                    .foregroundColor(Color("Leader Divider Clr"))
                                    .modifier(dividerStyle())
                            }
                        }
                    }
                    Spacer()
                }
                .frame(width: geo.size.width / 1.1, height: geo.size.height)
            }
        }
        .onAppear() {
            // sort orders before displaying
            model.sortPlayerInScore()
        }
    }
}
