//
//  MenuView.swift
//  PlayNow
//
//  Created by Nhung Tran on 17/08/2022.
// https://stackoverflow.com/questions/61424225/macos-swiftui-navigation-for-a-single-view
// https://stackoverflow.com/questions/63298599/align-images-with-same-size-and-aspect-ratio-fill-in-swiftui

import SwiftUI

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
    
    enum NavigationDestination: Int {
        case play
        case leader
        case switchUser
    }
    private func subView(forIndex index: Int) -> AnyView {
        switch index {
        case NavigationDestination.play.rawValue: return AnyView(PlayView(showingSubview: $showingSubview).frame(maxWidth: .infinity, maxHeight: .infinity))
        case NavigationDestination.leader.rawValue: return AnyView(LeaderboardView(showingSubview: $showingSubview).frame(maxWidth: .infinity, maxHeight: .infinity))
        case NavigationDestination.switchUser.rawValue: return AnyView(UsernameListView().frame(maxWidth: .infinity, maxHeight: .infinity))
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
                             VStack(alignment: .leading) {
                                 Text("Paper".uppercased())
                                 Text("Footbal".uppercased())
                             }
                             .font(.custom("EASPORTS", size: geometry.size.width / 15))
                                 .foregroundColor(.white)
                         }
                         .frame(width: geometry.size.width / 3, height: geometry.size.height / 7)
                         
                         Spacer()
                         
                         // MARK: button region
                         ZStack(alignment: .center) {
                             Rectangle()
                                 .opacity(0.5)
                                 .cornerRadius(cornerRadius, corners: [.topLeft, .topRight])
                             VStack(spacing: spacing) {
                                 
                                 Spacer()
                                 // Username display and changing
                                 UsernameView(isShowChangeUsername: $isShowChangeUsername)
                                 
                                 // MARK: navigation view
                                 
                                 // Play view
                                 Button(action: {
                                     self.showSubview(withIndex: NavigationDestination.play.rawValue)
                                     SoundModel.stopBackgroundMusic()
                                     SoundModel.startBackgroundMusic(bckName: "game", type: "mp3")
                                 }) {
                                     RectangleButtonView(bckColor: Color("Menu Button BckClr"), txtColor: Color("Menu Button TxtClr"), txt: "Play  Game".uppercased(), height: buttonHeight)
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
                                 }) {
                                     RectangleButtonView(bckColor: Color("Menu Button BckClr"), txtColor: Color("Menu Button TxtClr"), txt: "Switch  User".uppercased(), height: buttonHeight)
                                 }
                             }
                             .padding(.vertical, geometry.size.height / 20)
                             .padding(.horizontal, geometry.size.width / 15)
                         }
//                         .padding(.vertical, geometry.size.height / 10)
//                         .padding(.horizontal, geometry.size.width / 15)
                         .frame(maxWidth: .infinity, maxHeight: geometry.size.height / 2.5)
                     }
                     
                     if isShowChangeUsername {
                         UsernameChangeView(isShowChangeUsername: $isShowChangeUsername, width: modalWidth, height: modalHeight, buttonHeight: modalHeight / 10)
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
                 modalWidth = geometry.size.width / 1.5
                 modalHeight = geometry.size.height / 1.7
                 
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
