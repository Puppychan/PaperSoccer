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
 https://stackoverflow.com/questions/56760335/round-specific-corners-swiftui
 */

import SwiftUI

extension View {
    //    #if !os(macOS)
    // MARK: corner radius (can choose only a corner instead of 4 corners)
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
    
    
}
