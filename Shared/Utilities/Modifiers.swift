/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 2
  Author: Tran Mai Nhung
  ID: s3879954
  Created  date: 15/08/2022
  Last modified: 29/08/2022
  Acknowledgement: Tom Huynh github, canvas
 // https://thehappyprogrammer.com/custom-textfield-in-swiftui
*/


import SwiftUI
// for faster styling

// MARK: - modifier
// MARK: modal
// modal style
struct modalStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(Constants.cornerRadius)
            .shadow(color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.5), radius: 10, x: -5, y: 5)
    }
}


// opacity of the background when open modal
struct opacityModalOpen: ViewModifier {
    var isShowModal: Bool
    func body(content: Content) -> some View {
        content
            .opacity(isShowModal ? 0.3 : 1)
            .brightness(isShowModal ? -0.5 : 0)
    }
}
// modal padding
struct modalPadding: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, Constants.horizontalPadding)
            .padding(.vertical, Constants.verticalPadding + 10)
    }
}

// MARK: divider
struct dividerStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(height: 1.4)
            .opacity(0.4)
    }
}

// MARK: - custom style
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
