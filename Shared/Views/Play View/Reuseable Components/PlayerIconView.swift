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

struct PlayerIconView: View {
    var nameImage: String
    var geo: GeometryProxy
    var body: some View {
        Image(nameImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: geo.size.width / 8, height: geo.size.width / 8)
    }
}
