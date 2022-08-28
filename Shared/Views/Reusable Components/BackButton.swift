//
//  BackButton.swift
//  PaperSoccer
//
//  Created by Nhung Tran on 28/08/2022.
//

import SwiftUI

struct BackButton: View {
    @Binding var showingSubview: Bool
    @EnvironmentObject var model: GameModel
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        Button(action: {
            showingSubview = false
            model.exitGame()
        }, label: {
            ZStack {
                Circle()
                  .stroke(Color.red, lineWidth: 4)
                  .background(Circle().fill(Color.green))
                    
                Text("Back")
            }
            .frame(width: width, height: height)
        })
    }
}
