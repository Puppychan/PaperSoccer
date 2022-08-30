//
//  MenuView.swift
//  PlayNow
//
//  Created by Nhung Tran on 17/08/2022.
// https://stackoverflow.com/questions/61424225/macos-swiftui-navigation-for-a-single-view
// https://stackoverflow.com/questions/63298599/align-images-with-same-size-and-aspect-ratio-fill-in-swiftui

import SwiftUI
enum NavigationDestination: Int {
    case playEasy
    case playNormal
    case playHard
    case leader
    case switchUser
    case instruction
    case badge
}
struct MenuView: View {
    
    @EnvironmentObject var model: GameModel
    
    @State private var buttonHeight: CGFloat = 0
    @State private var buttonWidth: CGFloat = 0
    @State private var cornerRadius: CGFloat = 0
    @State private var modalWidth: CGFloat = 0
    @State private var modalHeight: CGFloat = 0
    @State private var spacing: CGFloat = 0
    
    @State private var currentSubviewIndex = 0
    @State private var showingSubview = false
    
    @State private var isShowChangeUsername = false
    
    @State private var isShowDiffiModes = false
    @State private var difficulty = ""
    

    private func subView(forIndex index: Int) -> AnyView {
        switch index {
            
            // play
//        case NavigationDestination.play.rawValue: return AnyView(PlayView(showingSubview: $showingSubview).frame(maxWidth: .infinity, maxHeight: .infinity))
        case NavigationDestination.playEasy.rawValue:
            return AnyView(PlayView(showingSubview: $showingSubview, difficulty: $difficulty).frame(maxWidth: .infinity, maxHeight: .infinity))
            
        case NavigationDestination.playNormal.rawValue:
            return AnyView(PlayView(showingSubview: $showingSubview, difficulty: $difficulty).frame(maxWidth: .infinity, maxHeight: .infinity))
            
        case NavigationDestination.playHard.rawValue:
            return AnyView(PlayView(showingSubview: $showingSubview, difficulty: $difficulty).frame(maxWidth: .infinity, maxHeight: .infinity))
            
            // leaderboard
        case NavigationDestination.leader.rawValue: return AnyView(LeaderboardView(showingSubview: $showingSubview, showFunc: showSubview).frame(maxWidth: .infinity, maxHeight: .infinity))
            
            // badge
        case NavigationDestination.badge.rawValue: return AnyView(BadgeView(showingSubview: $showingSubview)
            .frame(maxWidth: .infinity, maxHeight: .infinity))
            
            // switch user
        case NavigationDestination.switchUser.rawValue: return AnyView(UsernameListView(showingSubview: $showingSubview).frame(maxWidth: .infinity, maxHeight: .infinity))
            
            // instruction view
        case NavigationDestination.instruction.rawValue: return AnyView(InstructionView(showingSubview: $showingSubview).frame(maxWidth: .infinity, maxHeight: .infinity))
        default: return AnyView(Text("Inavlid Selection").frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.red))
        }
    }
    
    private func showSubview(withIndex index: Int) {
        currentSubviewIndex = index
        showingSubview = true
    }
    var body: some View {

        
        GeometryReader { geometry in
            StackNavigationView(
                 currentSubviewIndex: self.$currentSubviewIndex,
                 showingSubview: self.$showingSubview,
                 subviewByIndex: { index in
                     self.subView(forIndex: index)
                 }
             ) {
                 ZStack {
                     // MARK: background
                     ImageBackground(name: "soccer-bck-light")
                     VStack {
                         // MARK: title game
                         ZStack {
                             Rectangle()
                             VStack(alignment: .center) {
                                 Text("Paper".uppercased())
                                 Text("Football".uppercased())
                             }
                             .padding(.vertical)
                             .font(.custom("EASPORTS", size: geometry.size.width / 8))
                                 .foregroundColor(Color("Menu Title TxtClr"))
                         }
                         .frame(width: geometry.size.width, height: geometry.size.height / 7)
                         .foregroundColor(Color("Menu Title BckClr"))
                         .padding(.top, geometry.size.width / 3.5)
                         
                         Spacer()
                         
                         // MARK: button region
                         ZStack(alignment: .center) {
                             Rectangle()
                                 .opacity(0.6)
                                 .foregroundColor(Color("Menu BckClr"))
                                 .cornerRadius(cornerRadius)
//                                 .cornerRadius(cornerRadius, corners: [.topLeft, .topRight])
                             VStack(spacing: spacing) {
                                 
                                 Spacer()
                                 // Username display and changing
                                 UsernameView(isShowChangeUsername: $isShowChangeUsername)
                                 
                                 // MARK: navigation view
                                 
                                 // Play view
                                 Button(action: {
//                                     self.showSubview(withIndex: NavigationDestination.play.rawValue)
                                     
                                     isShowDiffiModes = true
                                     isShowChangeUsername = false

                                 }) {
                                     RectangleButtonView(bckColor: Color("Menu Button BckClr"), txtColor: Color("Menu Button TxtClr"), txt: "Play  Game".uppercased(), height: buttonHeight)
                                 }
                                 
                                 // Instruction view
                                 Button(action: {
                                     self.showSubview(withIndex: NavigationDestination.instruction.rawValue)
//                                     SoundModel.stopBackgroundMusic()
//                                     SoundModel.startBackgroundMusic(bckName: "game", type: "mp3")
                                 }) {
                                     RectangleButtonView(bckColor: Color("Menu Button BckClr"), txtColor: Color("Menu Button TxtClr"), txt: "Instruction".uppercased(), height: buttonHeight)
                                 }
                                 
                                 // Leaderboard view
                                 Button(action: {
                                     self.showSubview(withIndex: NavigationDestination.leader.rawValue)
                                     SoundModel.stopBackgroundMusic()
                                     SoundModel.startBackgroundMusic(bckName: "leaderboard", type: "mp3")
                                     
                                 }) {
                                     RectangleButtonView(bckColor: Color("Menu Button BckClr"), txtColor: Color("Menu Button TxtClr"), txt: "Leaderboard".uppercased(), height: buttonHeight)
                                 }
                                 
                                 // change username view
                                 Button(action: {
                                     self.showSubview(withIndex: NavigationDestination.switchUser.rawValue)
                                     SoundModel.stopBackgroundMusic()
                                     SoundModel.startBackgroundMusic(bckName: "switch", type: "mp3")
                                 }) {
                                     Text("Switch User".uppercased())
                                         .font(.custom("Roboto-Medium", size: geometry.size.width / 18))
                                         .foregroundColor(Color("Menu Button BckClr"))
                                         .underline()
                                 }
                                 .buttonStyle(.plain)
                                 Spacer()
                             }
                             .padding(.bottom, geometry.size.height / 25)
                             .padding(.horizontal, geometry.size.width / 15)
                         }
//                         .padding(.vertical, geometry.size.height / 10)
//                         .padding(.horizontal, geometry.size.width / 15)
                         .frame(maxWidth: .infinity, maxHeight: geometry.size.height / 2.2)
                     }
                     .opacity(isShowChangeUsername || isShowDiffiModes ? 0.6 : 1)
                     .brightness(isShowChangeUsername || isShowDiffiModes ? -0.4 : 0)
                     .ignoresSafeArea()
                     
                     if isShowChangeUsername {
                         UsernameChangeView(isShowChangeUsername: $isShowChangeUsername, width: modalWidth, height: modalHeight, buttonHeight: modalHeight / 6)
                     }
                     if isShowDiffiModes {
                         DifficultiesModal(difficulty: $difficulty, isShowDiffiModes: $isShowDiffiModes, width: modalWidth, height: modalHeight, showFunc: showSubview)
                     }
                 }

                 
             }
             .onAppear() {
                 // button
                 buttonHeight = geometry.size.height / 13
                 buttonWidth = geometry.size.width / 1.7
                 // others
                cornerRadius = geometry.size.width / 13.5
                 spacing = geometry.size.height / 35
                     // modal
                 modalWidth = geometry.size.width / 1.1
                 modalHeight = geometry.size.height / 2.5
                 
                 SoundModel.startBackgroundMusic(bckName: "menu", type: "mp3")
             }
            
        }
        
    }
        
}


struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
            .environmentObject(GameModel())
    }
}
