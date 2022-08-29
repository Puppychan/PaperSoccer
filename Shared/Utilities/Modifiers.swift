//
//  Modifiers.swift
//  PaperSoccer
//
//  Created by Nhung Tran on 28/08/2022.
// https://thehappyprogrammer.com/custom-textfield-in-swiftui

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

//struct movingLineStyle: ViewModifier {
//    var color: Color
//    func body(content: Content) -> some View {
//        content
//            .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .miter, miterLimit: 0, dash: [], dashPhase: 0))
//            .foregroundColor(color)
//            .animation(.easeInOut(duration: 0.3), value: 1)
//    }
//}
struct CustomTextFieldStyle: TextFieldStyle {
    var width: CGFloat
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(width / 15)
            .foregroundColor(Color("Text Field TxtClr"))
            .background(LinearGradient(gradient: Gradient(colors: [Color("Text Field BckClr"), Color("Text Field BckClr")]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(width / 10)
    }
}
struct modalPadding: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, Constants.horizontalPadding)
            .padding(.vertical, Constants.verticalPadding + 10)
    }
}
struct dividerStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(height: 1.4)
            .opacity(0.4)
    }
}
