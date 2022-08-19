//
//  GameContentView.swift
//  PaperSoccer
//
//  Created by Nhung Tran on 19/08/2022.
// https://talk.objc.io/episodes/S01E244-detecting-taps
// https://stackoverflow.com/questions/59109138/how-to-implement-a-left-or-right-draggesture-that-trigger-a-switch-case-in-swi

import SwiftUI
enum DragDirection: String {
    case north = "top none", east = "none right", west = "none left", south = "bottom none", northeast = "top right", northwest = "top left", southeast = "bottom right", southwest = "bottom left", none = "none none"
}
struct GameContentView: View {


    let columns: [GridItem] = [GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())]
    let totalCountItems = 9
    @State var itemPositions = [CGPoint]()
    @State var path = Path()
    @State var dragDirection: DragDirection = DragDirection.none
    @State var currentIndex = 0
    var body: some View {
        GeometryReader { geo in
            ZStack {
                LazyVGrid(columns: columns, spacing: 30) {
                    ForEach(0..<9) { index in
                        Circle()
                            .frame(width: 30)
                            .onAppear(perform: {
                            if itemPositions.count != totalCountItems {
                                itemPositions.append(CGPoint(x: geo.frame(in: .local).maxX, y: geo.frame(in: .local).maxY))
                            }
                        })
                        //                        .gesture(
                        //                        DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        //                            .onEnded { state in

                        //                        }
                        //                    )
                        .gesture(
                            DragGesture(minimumDistance: 0, coordinateSpace: .global)
                                .onEnded { value in
                                var horizontalDirection = "", verticalDirection = ""


                                if value.startLocation.x > value.location.x {
                                    // left
                                    horizontalDirection = "left"
                                } else if value.startLocation.x == value.location.x {
                                    horizontalDirection = "none"
                                } else {
                                    horizontalDirection = "right"
                                }

                                if value.startLocation.y > value.location.y {
                                    // left
                                    verticalDirection = "up"
                                } else if value.startLocation.y == value.location.y {
                                    verticalDirection = "none"
                                } else {
                                    verticalDirection = "down"
                                }
                                dragDirection = DragDirection(rawValue: "\(verticalDirection) \(horizontalDirection)") ?? .none
//                                if path.isEmpty {
//                                    path.move(to: value.startLocation)
//                                } else {
//                                    path.addLine(to: value.startLocation)
//                                }
                                let currentLocation = CGPoint(x: value.startLocation.x, y: value.startLocation.y - 47)
                                if path.isEmpty {
//                                        path.move(to: itemPositions[index + 1])
                                    path.move(to: currentLocation)
                                }
//                                    path.addLine(to: <#T##CGPoint#>)
                                path.addLine(to: itemPositions[index + 1])
                                    path.addLine(to: itemPositions[index + 1+1])
                            }
                        )

                    }
                }
                path.stroke(Color.black, lineWidth: 2)
            }
        }
    }

}

struct GameContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameContentView()
    }
}
