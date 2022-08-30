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

struct ImageBackground: View {
    // for display background as image but still stay in the center
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
