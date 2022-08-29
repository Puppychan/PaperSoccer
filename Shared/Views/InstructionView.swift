//
//  InstructionView.swift
//  PaperSoccer
//
//  Created by Nhung Tran on 29/08/2022.
//

import SwiftUI

struct InstructionView: View {
    @EnvironmentObject private var model: GameModel
    @Binding var showingSubview: Bool
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color("Instruction Head BckClr")
                VStack(alignment: .center, spacing: 10) {

//                    ZStack {
////                        ImageBackground(name: "soccer-bck")
////                            .brightness(-0.3)
////                            .opacity(0.5)
////                            .background(Color("Instruction Head BckClr"))
////                        Rectangle()
////                            .foregroundColor(Color("Instruction Head BckClr"))
//
//
//                    }
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
                            Text("Paper".uppercased())
                                .tracking(1)
                            Text("Football".uppercased())
                                .tracking(1)
                        }
                            .font(.custom("EASPORTS", size: geo.size.width / 8))
                            .foregroundColor(Color("Instruction Head TxtClr"))
                        Spacer()
                    }
                    .frame(width: geo.size.width, height: geo.size.height / 3, alignment: .center)
                        

                    Form {
                        Section(header: Text("How To Play")) {
                            Text("Just spin the reels to play.")
                            Text("Matching all icons to win.")
                            Text("The winning amount will be 10x of your betting amount.")
                            Text("You can reset the money and highscore by clicking on the button Reset.")
                        }
                        Section(header: Text("Application Information")) {
                            HStack {
                                Text("App Name")
                                Spacer()
                                Text("Paper Football")
                            }
                            HStack {
                                Text("Author")
                                Spacer()
                                Text("Nhung Tran")
                            }
                            HStack {
                                Text("Year Published")
                                Spacer()
                                Text("2022")
                            }
                            HStack {
                                Text("Location")
                                Spacer()
                                Text("Saigon South Campus")
                            }
                        }
                    }
                        .font(.system(.body, design: .rounded))
                }
                .padding(.top, geo.size.width / 10)

            }
            .onAppear(perform: {
                model.updateReadInstruction()
            })

        }
    }
}
