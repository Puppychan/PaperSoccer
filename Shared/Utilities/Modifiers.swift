//
//  Modifiers.swift
//  PaperSoccer
//
//  Created by Nhung Tran on 28/08/2022.
//

import SwiftUI
//
//struct appearAnimation: ViewModifier {
//    var duration: CGFloat
//    func body(content: Content) -> some View {
//        content
//
//    }
//}
struct modalStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(Constants.cornerRadius)
            .shadow(color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.5), radius: 10, x: -5, y: 5)
    }
}

struct opacityModalOpen: ViewModifier {
    var isShowModal: Bool
    func body(content: Content) -> some View {
        content
            .opacity(isShowModal ? 0.3 : 1)
            .brightness(isShowModal ? -0.5 : 0)
    }
}
