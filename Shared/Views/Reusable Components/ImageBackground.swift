//
//  ImageBackground.swift
//  PaperSoccer
//
//  Created by Nhung Tran on 26/08/2022.
//

import SwiftUI

struct ImageBackground: View {
    var name: String
    var opacity = 0.8
    var brightness = -0.02
    var body: some View {
        Color.clear.overlay(
              Image(name)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .opacity(opacity)
                .brightness(brightness)
            )
            .edgesIgnoringSafeArea(.all)
    }
}
