//
//  GameContentView.swift
//  PaperSoccer
//
//  Created by Nhung Tran on 19/08/2022.
// https://talk.objc.io/episodes/S01E244-detecting-taps
// https://stackoverflow.com/questions/59109138/how-to-implement-a-left-or-right-draggesture-that-trigger-a-switch-case-in-swi
// https://stackoverflow.com/questions/27517632/how-to-create-a-delay-in-swift
// https://stackoverflow.com/questions/66748286/swiftui-create-a-animating-circle

import SwiftUI


struct GameView: View {
    // pass from other classes
    @Binding var humanWinStatus: WinningType
    @Binding var isShowModal: Bool
    //    @State var playMode: String = "hard"
    @Binding var playMode: String
    var screenWidth: CGFloat
    var screenHeight: CGFloat

    @EnvironmentObject var model: GameModel
    @EnvironmentObject var contentModel: GameContentModel

    // init when appear
    @State var offsetX: CGFloat = 0
    @State var offsetY: CGFloat = 0
    @State var itemPositions: [[CGPoint]] = [[]]

    // detail size variables
    @State var spacingGrid: CGFloat = 0
    @State var circleSize: CGFloat = 0

    // action variables
    @State var isDisableBoard = false
    @State var isConfirmMove = false

    @State var isFirstMatch = true

    @State var isHumanMove = true
    @State var isBotMove = false
    @State var startHuman: CGPoint = CGPoint(x: 0, y: 0)
    @State var startBot: CGPoint = CGPoint(x: 0, y: 0)

    let duration = 1.0
    @State var appearYet = false

    @State var scale = 0.5
    @State var circleSizeAnnotation: CGFloat = 50

    init(winStatus humanWinStatus: Binding<WinningType>, showModal isShowModal: Binding<Bool>, playMode: Binding<String>, screenWidth: CGFloat, screenHeight: CGFloat) {
        self._humanWinStatus = humanWinStatus
        self._isShowModal = isShowModal
        self._playMode = playMode
        self.screenWidth = screenWidth
        self.screenHeight = screenHeight
    }

    // check if user win after every steps
    private func checkInMatchWin() async {
        // check win status
        humanWinStatus = contentModel.humanWinStatus
        if humanWinStatus != .none {
            // sound before opening the modal
            SoundModel.stopBackgroundMusic()
            if humanWinStatus == .humanWin {
                SoundModel.playSound(sound: "football-\(humanWinStatus.rawValue)", type: "mp3")
            }
            else {
                SoundModel.playSound(sound: "football-\(humanWinStatus.rawValue)", type: "wav")
            }

            // wait for opening the modal
            try? await Task.sleep(nanoseconds: UInt64(3 * Double(NSEC_PER_SEC)))
            // sound after opening the modal
            SoundModel.playSound(sound: "result-\(humanWinStatus.rawValue)", type: "wav")
            // if win or lose or draw -> display modal
            isShowModal.toggle()
            // update current scores
            model.updateScores(winStatus: humanWinStatus)
            // reset game
            contentModel.resetGame()
        }
    }

    private func computerMoveTurn() async {
        try? await Task.sleep(nanoseconds: UInt64(1 * Double(NSEC_PER_SEC)))
        isHumanMove = false
        let arr = contentModel.displayComputerMove(mode: playMode, itemPositions: itemPositions)

        self.contentModel.humanMoveValid = false
        isDisableBoard = false
    }


    var body: some View {
        GeometryReader { geo in
            ZStack {


                StadiumView(contentModel: contentModel, offsetX: offsetX, offsetY: offsetY, spacingGrid: spacingGrid, circleSize: circleSize, duration: duration)
                LazyVStack(spacing: spacingGrid) {

                    ForEach(0..<contentModel.map.count) { i in

                        HStack(spacing: spacingGrid) {
                            ForEach(0..<contentModel.map[0].count) { j in
                                let checkIgnoreIndex = contentModel.isIgnorePosition(forRow: i, forCol: j)
                                let checkBouncingIndex = contentModel.isBorderIndex(forX: j, forY: i)

                                ZStack {
                                    if (checkIgnoreIndex && contentModel.isIgnorePosition(forRow: i, forCol: j + 1) && contentModel.isIgnorePosition(forRow: i + 1, forCol: j + 1) && contentModel.isIgnorePosition(forRow: i + 1, forCol: j)) {
                                    }
                                    if (checkBouncingIndex) {
                                        Circle()
                                            .frame(width: circleSize / 3, height: circleSize / 3)
                                            .foregroundColor(Color("Game Circle BckClr"))
                                            .opacity(appearYet ? 0.45 : 0.0)
                                    }
                                    Circle()
                                        .frame(width: circleSize, height: circleSize)
                                        .opacity(appearYet ? (checkIgnoreIndex || checkBouncingIndex ? 0.01 : 0.3) : 0.0)
                                        .foregroundColor(Color("Game Circle BckClr"))
                                        .onAppear(perform: {

                                        itemPositions[i][j] = CGPoint(
                                            x: offsetX + CGFloat(j) * (spacingGrid + circleSize),
                                            //                                            x: offsetX,
                                            y: offsetY + CGFloat(i) * (spacingGrid + circleSize)
                                        )
                                        // if start position
                                        if i == contentModel.totalRows / 2 && j == contentModel.totalColumns / 2 {
                                            contentModel.humanStart = itemPositions[i][j]
                                            contentModel.humanEnd = itemPositions[i][j]
                                        }
                                    })
                                        .onTapGesture(perform: {
                                        print(i, j)
                                    })
                                        .gesture(
                                        DragGesture(minimumDistance: 0, coordinateSpace: .global)
                                            .onEnded { value in
                                            //                                                self.vm.points.append(value.location)
                                            if !checkIgnoreIndex {
                                                isHumanMove = true
                                                // add movement
                                                print("-------------------------------")

                                                contentModel.defineHumanMovement(itemPositions: itemPositions, dragValue: value)

                                                // check if moving -> add animation
//                                                if !oldIndex.equals(newIndex) {
//                                                    isHumanMove = true
//                                                }
                                                if contentModel.humanMoveValid {
                                                    isDisableBoard = true
                                                    Task {
                                                        // check winning
                                                        await checkInMatchWin()

                                                        // prevent display draw after display winning
                                                        if humanWinStatus != .none {
                                                            isDisableBoard = false
                                                            return
                                                        }
                                                        isHumanMove = false
                                                        isBotMove = true

                                                        await computerMoveTurn()

                                                        // check winning
                                                        await checkInMatchWin()
                                                        isHumanMove = true
                                                        if contentModel.humanWinStatus != .none {
                                                            return
                                                        }
                                                    }

                                                }
                                            }
                                        }
                                    ) }
                            }
                        }

                    }
                }
                    .disabled(isDisableBoard)

                contentModel.botPath.stroke(Color.blue, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                contentModel.humanPath.stroke(Color.yellow, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                Circle()

                    .foregroundColor(isHumanMove ? Color.yellow : Color.blue)
                    .scaleEffect(scale)
                    .opacity(scale)

                    .frame(width: circleSizeAnnotation, height: circleSizeAnnotation, alignment: .center)
                    .position(x: contentModel.humanStart.x, y: contentModel.humanStart.y)
                    .animation(
                    Animation.easeInOut(duration: 0.8)
                        .repeatForever().delay(0), value: scale
                )


                    .onAppear {
                    self.scale = self.scale != 1 ? 1 : 0.5
                }
            }
                .animation(
                Animation.easeInOut(duration: duration + 0.5), value: appearYet
            )
                .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                    appearYet.toggle()
                    circleSizeAnnotation = circleSize / 1.2
                }

                //                spacingGrid = screenHeight / 13.2 // 30
                spacingGrid = screenHeight / 20
                circleSize = screenWidth / 22 // 20


                offsetY = geo.frame(in: .local).midY - (CGFloat(contentModel.totalRows / 2) * (spacingGrid + circleSize))
                offsetX = geo.frame(in: .local).midX - (CGFloat(contentModel.totalColumns / 2) * (spacingGrid + circleSize))

                itemPositions = [[CGPoint]](repeating: [CGPoint](repeating: CGPoint(x: 0, y: 0), count: contentModel.totalColumns), count: contentModel.totalRows)

            }
        }
    }
}
