//
//  GameContentView.swift
//  PaperSoccer
//
//  Created by Nhung Tran on 19/08/2022.
// https://talk.objc.io/episodes/S01E244-detecting-taps
// https://stackoverflow.com/questions/59109138/how-to-implement-a-left-or-right-draggesture-that-trigger-a-switch-case-in-swi

import SwiftUI

struct GameContentView: View {
    // pass from other classes
    @Binding var humanWinStatus: WinningType
    @Binding var isShowModal: Bool

    @EnvironmentObject var model: GameModel
    @EnvironmentObject var contentModel: GameContentModel

    // init when appear
    @State var offsetX: CGFloat = 0
    @State var offsetY: CGFloat = 0
    @State var spacingGrid: CGFloat = 0
    @State var circleSize: CGFloat = 0

    @State var isDisableBoard = false
    @State var isConfirmMove = false

    @State var itemPositions = [CGPoint]()
    let parentGeo: GeometryProxy
    @State var screenWidth: CGFloat = 0
    @State var screenHeight: CGFloat = 0

    init(winStatus humanWinStatus: Binding<WinningType>, showModal isShowModal: Binding<Bool>, parentGeo: GeometryProxy) {
        self.parentGeo = parentGeo
        self._humanWinStatus = humanWinStatus
        self._isShowModal = isShowModal

    }

    // check if user win after every steps
    func checkInMatchWin() {
        // check win status
        humanWinStatus = contentModel.checkWinning()
        if humanWinStatus != .none {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                // if win or lose or draw -> display modal
                isShowModal.toggle()
            }
        }
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                LazyVGrid(columns: contentModel.columns, spacing: spacingGrid) {
                    var currentColumnIndex = 0, currentRowIndex = 0
                    ForEach(0..<contentModel.totalCountItems, id: \.self) { index in
                        let checkIgnoreIndex = contentModel.checkIgnorePosition(for: index)
                        Circle()
                            .frame(width: circleSize, height: circleSize)
                            .opacity(checkIgnoreIndex ? 0 : 0.3)
                            .onAppear(perform: {

                            if (itemPositions.count != contentModel.totalCountItems) {
                                itemPositions.append(CGPoint(
                                    x: offsetX + CGFloat(currentColumnIndex) * (screenWidth / CGFloat(contentModel.totalColumns)),
//                                    x: offsetX,
                                    y: offsetY + CGFloat(currentRowIndex) * (spacingGrid + circleSize)
//                                    y: offsetY
                                    ))
                            }
                            currentColumnIndex += 1
                            if currentColumnIndex == contentModel.totalColumns {
                                currentColumnIndex = 0
                                currentRowIndex += 1
                            }
                        })
                            .onTapGesture(perform: {
                            print(index)
                        })
                            .gesture(
                            DragGesture(minimumDistance: 0, coordinateSpace: .global)
                                .onEnded { value in
                                if !checkIgnoreIndex {

                                    // add movement
                                    contentModel.defineMovement(itemPositions: itemPositions, dragValue: value)
                                    if contentModel.humanMoveValid {
                                        isDisableBoard = true

                                        // check winning
                                        checkInMatchWin()
//                                    if isConfirmMove {
//
//                                    }
//                                    isConfirmMove = false

                                        // computer moves
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                                            contentModel.findComputerMove(itemPositions: itemPositions)

                                            self.contentModel.humanMoveValid = false
                                        isDisableBoard = false

                                            // check winning
                                            checkInMatchWin()
                                        }
                                    }
                                }
                            }
                        )


                    }
                }
                    .onAppear() {
//                    screenWidth = parentGeo.size.width * 0.9
//                    screenHeight = parentGeo.size.height -  (parentGeo.size.height / 4.5) * 2
                    screenWidth = 350
                    screenHeight = 400
                }
                    .disabled(isDisableBoard)
                contentModel.humanPath.stroke(Color.blue, lineWidth: 2)
                contentModel.botPath.stroke(Color.red, lineWidth: 2)
//                HStack {
//                    Spacer()
//                    Button(action: {
//                        isConfirmMove = true
//                    }, label: {
//                            Text("Confirm")
//
//                        })
//                }
//                    .position(CGPoint(x: geo.frame(in: .local).minX, y: geo.frame(in: .local).maxY))

            }
                .onAppear {
                print(parentGeo.size.width / 1.1, screenWidth, geo.size.width)
                spacingGrid = screenHeight / 13.2 // 30
                circleSize = screenWidth / 20 // 20
                let midUpperY = (spacingGrid + circleSize) * CGFloat((contentModel.totalRowNum / 2))
                offsetX = geo.frame(in: .local).minX + screenWidth / CGFloat((contentModel.totalColumns * 2))
//                    offsetX = geo.frame(in: .local).minX + (screenWidth / CGFloat(contentModel.totalColumns * 2)) - (circleSize / 3.5)
//                    offsetX = geo.frame(in: .local).minX

                offsetY = geo.frame(in: .local).minY + (screenHeight / 2) - midUpperY
//                    offsetY = geo.frame(in: .local).minY
            }
        }
//        .frame(width: parentGeo.size.width * 0.9, height: parentGeo.size.height -  (parentGeo.size.height / 4.5) * 2)
        .frame(width: 350, height: 400)
    }

}

