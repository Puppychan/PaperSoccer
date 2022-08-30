/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2022B
 Assessment: Assignment 2
 Author: Tran Mai Nhung
 ID: s3879954
 Created  date: 15/08/2022
 Last modified: 29/08/2022
 Acknowledgement: https://stackoverflow.com/questions/34333881/get-the-first-word-in-a-string-of-words-spaces-substring-first-word-before-s
 */

import SwiftUI

struct BadgeView: View {
    @Binding var showingSubview: Bool
    @EnvironmentObject var model: GameModel
    var body: some View {
        GeometryReader { geo in
            let circleSize = geo.size.width / 6
            ZStack {
                // MARK: image background
                ImageBackground(name: "achie-bck")
                    .brightness(-0.65)
                    .opacity(0.6)
                    .background(Color("Achie BckClr"))
                VStack {
                    // MARK: back button
                    HStack {
                        BackButton(showingSubview: $showingSubview, width: geo.size.width / 10, height: geo.size.width / 10)
                        Spacer()
                    }
                    
                    Spacer()
                    
                    // MARK: title
                    Text("Your Badges".uppercased())
                        .font(.custom("EASPORTS", size: geo.size.width / 9))
                        .foregroundColor(Color("Achie Title TxtClr"))
                        .tracking(1)
                    
                    // MARK: badge list
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: geo.size.height / 22) {
                            ForEach(0..<model.badges.count, id: \.self) { index in
                                // check if user has contain that badge yet
                                let haveBadge = model.isHaveBadge(for: index)
                                
                                // MARK: 1 badge
                                HStack(spacing: geo.size.width / 22) {
                                    // Display badge image
                                    ZStack {
                                        Circle()
                                            .foregroundColor(.white)
                                            .shadow(color: Color("Achie BckClr"), radius: 10, x: -5, y: -5)
                                        Image("\(model.badges[index].components(separatedBy: " ").first!.lowercased())")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: circleSize / 1.3)
                                            .grayscale(haveBadge ? 0 : 0.75)
                                            .shadow(color: Color("Achie BckClr"), radius: 10, x: -5, y: -5)
                                    }
                                    .frame(width: circleSize, height: circleSize)
                                    
                                    // Badge name
                                    Text(model.badges[index])
                                        .font(.custom(
                                            haveBadge ? "Roboto-Medium" : "Roboto-Italic",
                                            size: geo.size.width / (haveBadge ?  15 : 17)))
                                        .foregroundColor(Color("Achie TxtClr"))
                                }
                                .opacity(haveBadge ? 1 : 0.5)
                                
                            }
                        }
                    }
                }
                .frame(width: geo.size.width / 1.1, height: geo.size.height / 1.07)
                .onAppear(perform: {
                    model.addBadges()
                })
            }
        }
    }
}
