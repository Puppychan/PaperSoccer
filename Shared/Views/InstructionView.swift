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

// Reusable Components

// display label
struct LabelInstruction: View {
    let text: String
    let width: CGFloat
    var body: some View {
        Label {
            Text(text)
        } icon:
        { Image("soccer-point")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width)
        }
    }
}

// display 2 image on same line
struct TwoImagesInstruction: View {
    let name1: String
    let name2: String
    let width: CGFloat
    var body: some View {
        HStack(spacing: 2) {
            ImageInstruction(name: name1, width: width)
            ImageInstruction(name: name2, width: width)
        }
    }
}
// display an instruction image
struct ImageInstruction: View {
    let name: String
    let width: CGFloat
    var body: some View {
        Image("\(name)")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: width)
    }
}

struct InstructionView: View {
    @EnvironmentObject private var model: GameModel
    @Binding var showingSubview: Bool
    var body: some View {
        GeometryReader { geo in
            let iconWidth = geo.size.width / 15
            let contentWidth = geo.size.width / 1.1
            ZStack {
                // MARK: background
                ImageBackground(name: "soccer-bck")
                    .brightness(-0.5)
                    .opacity(0.5)
                    .background(Color("Instruction Head BckClr"))
                VStack {
                    VStack {
                        // MARK: back button
                        HStack {
                            BackButton(showingSubview: $showingSubview, width: geo.size.width / 8, height: geo.size.width / 8)
                                .padding(.leading, geo.size.width / 17)
                            Spacer()
                        }
                        Spacer()
                        
                        // MARK: app name
                        VStack(spacing: geo.size.width / 20) {
                            Text("Paper Football".uppercased())
                                .tracking(1)
                            Text("Instruction".uppercased())
                                .tracking(1)
                        }
                        .font(.custom("EASPORTS", size: geo.size.width / 13))
                        .foregroundColor(Color("Instruction Head TxtClr"))
                        Spacer()
                    }
                    .frame(width: geo.size.width, height: geo.size.height / 5, alignment: .center)
                    
                    ScrollView {
                        // MARK: content
                        ZStack {
                            Rectangle()
                                .foregroundColor(Color("Instruction Contain BckClr"))
                                .opacity(0.9)
                            VStack(spacing: geo.size.height / 9) {
                                
                                // MARK: section content
                                VStack {
                                    ImageInstruction(name: "football stadium", width: contentWidth)
                                    LabelInstruction(text: "There will be 2 goals: the one in North region or yellow region is the bot or opponent’s goal, the goal in South region or blue region is the human’s goal. To win, the user has to put the ball to the opponent’s goal.", width: iconWidth)
                                    LabelInstruction(text: "When the ball is in blue color, it is the human’s turn. In contrast, when the ball is in yellow color, it is the computer’s turn.", width: iconWidth)
                                    Rectangle()
                                        .modifier(dividerStyle())
                                }
                                .frame(width: contentWidth)
                                
                                // MARK: section content
                                VStack {
                                    TwoImagesInstruction(name1: "instruct-1", name2: "instruct-2", width: contentWidth / 2)
                                    LabelInstruction(text: "To move, player drags their finger on the screen to the direction the player wants to move. The ball moves to the index based on the direction that user has dragged with the blue line. After finishing moving, the computer takes turn to move with the yellow line. ", width: iconWidth)
                                    LabelInstruction(text: "The first left image is when the user moves. The next image is when the computer moves after the user finishes moving", width: iconWidth)
                                    Rectangle()
                                        .modifier(dividerStyle())
                                }
                                .frame(width: contentWidth)
                                
                                // MARK: section content
                                VStack {
                                    TwoImagesInstruction(name1: "instruct-3", name2: "instruct-4", width: contentWidth / 2)
                                    LabelInstruction(text: "The user’s movement can have more than one lines or segments. The user has to continue to move the ball if the ball touches any lines or points created by other turns or when hitting the borders of stadium. In other words, the human movement can only be stopped until the ball hits the point that has not been touched by any turn.", width: iconWidth)
                                    LabelInstruction(text: "Besides, the user cannot move the ball to the line taken by previous players’ turns.", width: iconWidth)
                                    Rectangle()
                                        .modifier(dividerStyle())
                                }
                                .frame(width: contentWidth)
                                
                                // MARK: section content
                                VStack {
                                    ImageInstruction(name: "instruct-5", width: contentWidth)
                                    LabelInstruction(text: "The image above is when the user wins the game – when hitting the opponent’s goal", width: iconWidth)
                                }
                                .frame(width: contentWidth)
                            }
                            .foregroundColor(Color("Instruction Content TxtClr"))
                            .font(.custom("Roboto-Regular", size: geo.size.width / 22))
                            .padding(.vertical, geo.size.height / 15)
                        }
                    }
                    
                }
            }
            .onAppear(perform: {
                model.updateReadInstruction()
            })
            
        }
    }
}
