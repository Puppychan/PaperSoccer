//
//  ExtensionView.swift
//  PaperSoccer
//
//  Created by Nhung Tran on 26/08/2022.
// https://stackoverflow.com/questions/56760335/round-specific-corners-swiftui

import SwiftUI

extension View {
//    #if !os(macOS)
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
//    #endif
    func animate(using animation: Animation = .easeInOut(duration: 1), _ action: @escaping () -> Void) -> some View {
        onAppear {
            withAnimation(animation) {
                action()
            }
        }
    }
    
}
