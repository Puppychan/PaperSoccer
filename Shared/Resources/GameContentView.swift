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
    @State var offsetX: CGFloat = 0
    @State var offsetY: CGFloat = 0

    @State var itemPositions = [CGPoint]()
    @State var path = Path()
    @State var dragDirection: DragDirection = DragDirection.none
    @State var currentIndex = 0

    let totalCountItems = 9
    let totalColumns = 3
    let spacingGrid: CGFloat = 30
    let circleSize: CGFloat = 20
    var body: some View {
        GeometryReader { geo in
            ZStack {
                LazyVGrid(columns: columns, spacing: spacingGrid) {
                    var currentColumnIndex = 0, currentRowIndex = 0
                    ForEach(0..<9) { index in
                        Circle()
                            .frame(width: circleSize, height: circleSize)
                            .opacity(0.3)
                            .onAppear(perform: {

                            if itemPositions.count != totalCountItems {
                                itemPositions.append(CGPoint(
                                    x: offsetX + CGFloat(currentColumnIndex) * (geo.size.width / 3),
                                    y: offsetY + CGFloat(currentRowIndex) * (spacingGrid + circleSize)))
                            }
                            currentColumnIndex += 1
                            if currentColumnIndex == totalColumns {
                                currentColumnIndex = 0
                                currentRowIndex += 1
                            }
                        })

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
                                    verticalDirection = "top"
                                } else if value.startLocation.y == value.location.y {
                                    verticalDirection = "none"
                                } else {
                                    verticalDirection = "bottom"
                                }
                                if path.isEmpty {
                                    path.move(to: itemPositions[currentIndex])
                                }
                                dragDirection = DragDirection(rawValue: "\(verticalDirection) \(horizontalDirection)") ?? .none
                                    var newIndex = currentIndex
                                    switch dragDirection {
                                    case .north:
                                        newIndex -= totalColumns
                                    case .east:
                                        newIndex += 1
                                    case .west:
                                        newIndex -= 1
                                    case .south:
                                        newIndex += totalColumns
                                    case .northeast:
                                        newIndex -= (totalColumns - 1)
                                    case .northwest:
                                        newIndex -= (totalColumns + 1)
                                    case .southeast:
                                        newIndex += (totalColumns + 1)
                                    case .southwest:
                                        newIndex += (totalColumns - 1)
                                    case .none:
                                        newIndex = currentIndex
                                    }
                                    if newIndex < 0 || newIndex >= totalCountItems {
                                        currentIndex = currentIndex
                                    }
                                    else {
                                        currentIndex = newIndex
                                    }
                                    print("\(verticalDirection) \(horizontalDirection)")
                                    print(dragDirection, currentIndex)
                                    path.addLine(to: itemPositions[currentIndex])
                            }
                        )

                    }
                }
                path.stroke(Color.black, lineWidth: 2)
            }
                .onAppear {
                offsetX = geo.frame(in: .local).minX + geo.size.width / 6
                offsetY = geo.frame(in: .local).minY + (geo.size.height / 2) - (spacingGrid + circleSize)
                currentIndex = (totalCountItems / totalColumns) + 1


            }
        }
    }

}

struct GameContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameContentView()
    }
}
