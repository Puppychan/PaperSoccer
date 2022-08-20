//
//  GameContentView.swift
//  PaperSoccer
//
//  Created by Nhung Tran on 19/08/2022.
// https://talk.objc.io/episodes/S01E244-detecting-taps
// https://stackoverflow.com/questions/59109138/how-to-implement-a-left-or-right-draggesture-that-trigger-a-switch-case-in-swi

import SwiftUI

struct GameContentView: View {
    @Binding var humanWinStatus: WinningType
    @Binding var isShowModal: Bool
    
    @EnvironmentObject var model: GameModel
    @EnvironmentObject var contentModel: GameContentModel

    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    @State var offsetX: CGFloat = 0
    @State var offsetY: CGFloat = 0

    @State var itemPositions = [CGPoint]()
    @State var path = Path()
    @State var dragDirection: DragDirection = DragDirection.none
    @State var currentIndex = 0

    let totalCountItems = 35
    var totalColumns = 0
    let spacingGrid: CGFloat = 30
    let circleSize: CGFloat = 20
    var totalRowNum = 0
    
    var ignoreRanges: [ClosedRange<Int>]
    var startFinalRowIndex = 0
    
    init(winStatus humanWinStatus: Binding<WinningType>, showModal isShowModal: Binding<Bool>) {
        totalColumns = columns.count
        totalRowNum = totalCountItems / totalColumns
        
        startFinalRowIndex = totalColumns * (totalRowNum - 1)
        let endLeftIndex = (totalColumns / 2) - 2
        let startRightIndex = (totalColumns / 2) + 2
        ignoreRanges = [0...endLeftIndex,
                        startRightIndex...totalColumns - 1,
                        startFinalRowIndex...(endLeftIndex + startFinalRowIndex),
                        startFinalRowIndex + startRightIndex...totalColumns - 1 + startFinalRowIndex
        ]
        
        self._humanWinStatus = humanWinStatus
        self._isShowModal = isShowModal
        
    }
    func checkInRanges(for index: Int) -> Bool {
        for range in ignoreRanges {
            if range ~= index {
                return true
            }
        }
        return false
    }
    func checkIgnorePosition(for index: Int) -> Bool {
        return ((index < totalColumns || index >= startFinalRowIndex) &&
        checkInRanges(for: index))
    }
    var body: some View {
        GeometryReader { geo in
            ZStack {
                LazyVGrid(columns: columns, spacing: spacingGrid) {
                    var currentColumnIndex = 0, currentRowIndex = 0
                    ForEach(0..<totalCountItems, id: \.self) { index in
                        let checkIgnoreIndex = checkIgnorePosition(for: index)
                        Text("\(index)")
                            .frame(width: circleSize, height: circleSize)
                            .opacity(checkIgnoreIndex ? 0 : 0.3)
                            .onAppear(perform: {

                                if (itemPositions.count != totalCountItems) {
                                    itemPositions.append(CGPoint(
                                        x: offsetX + CGFloat(currentColumnIndex) * (geo.size.width / CGFloat(totalColumns)),
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
                                        if !checkIgnoreIndex {
                                            if path.isEmpty {
                                                path.move(to: itemPositions[currentIndex])
                                            }
                                                dragDirection = ModelUtility.findDragDirection(startLocation: value.startLocation, location: value.location)
                                                
                                            var newIndex = contentModel.identifyNextMovementDrag(dragDirection: dragDirection, totalColumns: totalColumns, currentIndex: currentIndex)
                                            print("new index: ", newIndex)

                                            if newIndex < 0 || newIndex >= totalCountItems || checkIgnorePosition(for: newIndex) {
                                                currentIndex = currentIndex
                                            }
                                            else if newIndex == totalColumns / 2 || newIndex == (totalColumns - 1 - totalColumns / 2) {
                                                humanWinStatus = .humanWin
                                                isShowModal.toggle()
                                                currentIndex = newIndex
                                                path.addLine(to: itemPositions[currentIndex])
                                            }
                                            else {
                                                print(currentIndex, newIndex)
                                                currentIndex = newIndex
                                                path.addLine(to: itemPositions[currentIndex])
                                            }
                                        }
                                    }
                        )
                        

                    }
                }
                path.stroke(Color.black, lineWidth: 2)
            }
                .onAppear {
                let midUpperY = (spacingGrid + circleSize) * CGFloat((totalRowNum / 2))
                offsetX = geo.frame(in: .local).minX + geo.size.width / CGFloat((totalColumns * 2))
                offsetY = geo.frame(in: .local).minY + (geo.size.height / 2) - midUpperY
                currentIndex = totalCountItems / 2


            }
        }
        .frame(width: 400, height: 400)
    }

}

