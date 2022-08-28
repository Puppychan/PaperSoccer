//
//  ExtensionView.swift
//  PaperSoccer
//
//  Created by Nhung Tran on 26/08/2022.
// https://stackoverflow.com/questions/56760335/round-specific-corners-swiftui

import SwiftUI

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
    
}
