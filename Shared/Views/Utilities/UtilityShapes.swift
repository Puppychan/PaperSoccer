//
//  UtilityShapes.swift
//  PaperSoccer
//
//  Created by Nhung Tran on 26/08/2022.
// https://stackoverflow.com/questions/56760335/round-specific-corners-swiftui


import SwiftUI

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

