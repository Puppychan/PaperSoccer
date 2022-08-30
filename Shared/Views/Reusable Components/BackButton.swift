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

// Reusable back button
struct BackButton: View {
    @Binding var showingSubview: Bool
    @EnvironmentObject var model: GameModel
    var width: CGFloat
    var height: CGFloat
    
    var body: some View {
        Button(action: {
            showingSubview = false
            model.exitGame()
        }, label: {
            ZStack {
                Circle()
                  .stroke(Color("Back Button StrokeClr"), lineWidth: 4)
                  .background(Circle().fill(Color("Back Button BckClr")))
                    
                Text("<<")
                    .foregroundColor(Color("Back Button TxtClr"))
                    .font(.title)
            }
            .frame(width: width, height: height)
        })
    }
}
