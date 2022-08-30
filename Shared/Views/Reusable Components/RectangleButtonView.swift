/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2022B
 Assessment: Assignment 2
 Author: Tran Mai Nhung
 ID: s3879954
 Created  date: 15/08/2022
 Last modified: 29/08/2022
 Acknowledgement: Canvas, Tom Huynh github
 */


import SwiftUI

// For custom default button
struct RectangleButtonView: View {
    var bckColor: Color = Color(.white)
    var txtColor: Color = Color(.black)
    var fontName = "EASPORTS"
    var cornerRadius: CGFloat = Constants.cornerRadius
    var txt: String
    var height: CGFloat
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(bckColor)
                .frame(height: height)
                .cornerRadius(cornerRadius)
                .shadow(color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.3), radius: 7, x: -3, y: 3)
            
            Text(txt)
                .foregroundColor(txtColor)
                .font(.custom(fontName, size: height / 2.7))
                .tracking(2)
        }
        
    }
}
