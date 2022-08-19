//
//  RectangleButtonView.swift
//  PlayNow
//
//  Created by Nhung Tran on 18/08/2022.
//

import SwiftUI

struct RectangleButtonView: View {
    var bckColor: Color = Color(.white)
    var txtColor: Color = Color(.black)
    var txt: String
    var height: CGFloat
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(bckColor)
                .frame(height: height)
                .cornerRadius(Constants.cornerRadius)
                .shadow(color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.3), radius: 7, x: -3, y: 3)
            
            Text(txt)
                .foregroundColor(txtColor)
        }

    }
}
