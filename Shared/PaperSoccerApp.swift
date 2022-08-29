//
//  PaperSoccerApp.swift
//  Shared
//
//  Created by Nhung Tran on 19/08/2022.
//

import SwiftUI
@main
struct PaperSoccerApp: App {
    var body: some Scene {
        WindowGroup {
            MenuView()
                .environmentObject(GameModel())
//                .ifOS(.macOS) {
//                    $0.frame(width: 500, height: 820)
//                }
            #if os(macOS)
                .frame(width: 500, height: 820)
               #else
            
                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .frame(width: 500, height: 820)
               #endif
            
//            GameContentView()
        }
    }
}
