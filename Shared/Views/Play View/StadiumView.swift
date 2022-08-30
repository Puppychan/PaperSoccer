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
 // https://stackoverflow.com/questions/66748286/swiftui-create-a-animating-circle
 */


import SwiftUI

struct StadiumView: View {
    var contentModel: GameContentModel
    var offsetX: CGFloat
    var offsetY: CGFloat
    var spacingGrid: CGFloat
    var circleSize: CGFloat
    let duration: CGFloat
    
    @State var appearYet = false
    
    @State var evenOpacity = 0.7
    @State var oddOpacity = 0.9
    let brightness = -0.1
    
    var body: some View {
        ZStack {
            // draw bot region
            StadiumSquares(offsetX: offsetX, offsetY: offsetY, model: contentModel, isEvenSquare: true, spacingGrid: spacingGrid, circleSize: circleSize, isHumanPlace: false)
                .fill(Color("Stadium BckClr"))
                .brightness(brightness)
                .opacity(appearYet ? evenOpacity : 0)
            StadiumSquares(offsetX: offsetX, offsetY: offsetY, model: contentModel, isEvenSquare: false, spacingGrid: spacingGrid, circleSize: circleSize, isHumanPlace: false)
                .fill(Color("Stadium BckClr"))
                .opacity(appearYet ? oddOpacity : 0)
            
            // draw human region
            StadiumSquares(offsetX: offsetX, offsetY: offsetY, model: contentModel, isEvenSquare: true, spacingGrid: spacingGrid, circleSize: circleSize, isHumanPlace: true)
                .fill(Color("Stadium1 BckClr"))
                .brightness(brightness)
                .opacity(appearYet ? evenOpacity : 0)
            StadiumSquares(offsetX: offsetX, offsetY: offsetY, model: contentModel, isEvenSquare: false, spacingGrid: spacingGrid, circleSize: circleSize, isHumanPlace: true)
                .fill(Color("Stadium1 BckClr"))
                .opacity(appearYet ? oddOpacity : 0)
            
            // draw stadium border
            StadiumBorder(offsetY: offsetY, offsetX: offsetX, circleSize: circleSize, spacingGrid: spacingGrid, columns: contentModel.totalColumns, rows: contentModel.totalRows)
                .stroke(.blue, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                .brightness(brightness)
                .opacity(appearYet ? evenOpacity : 0)
        }
        .animation(
            Animation.easeInOut(duration: duration), value: appearYet
        )
        .onAppear {
            self.appearYet.toggle()
        }
    }
}
