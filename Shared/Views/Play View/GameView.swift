//
//  GameContentView.swift
//  PaperSoccer
//
//  Created by Nhung Tran on 19/08/2022.
// https://talk.objc.io/episodes/S01E244-detecting-taps
// https://stackoverflow.com/questions/59109138/how-to-implement-a-left-or-right-draggesture-that-trigger-a-switch-case-in-swi
// https://stackoverflow.com/questions/27517632/how-to-create-a-delay-in-swift

import SwiftUI


struct GameView: View {
//    @State var oldScreenSize = NSSize.zero
//    @State var currentScreenSize = NSSize.zero
//    @State var hasSizeChanged = false
//    var screenResChanged = NotificationCenter.default.publisher(for: NSApplication.didChangeScreenParametersNotification)
    
    // pass from other classes
    @Binding var humanWinStatus: WinningType
    @Binding var isShowModal: Bool
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

    @State var path: Path = Path()
    @State var isHumanMove = true
    @State var isBotMove = false
    @State var startHuman: CGPoint = CGPoint(x: 0, y: 0)
    @State var startBot: CGPoint = CGPoint(x: 0, y: 0)


    @ObservedObject var vm = RouteVM()
    @ObservedObject var botVm = RouteVM()

    @State var playMode: String = "easy"

    let duration = 1.0
    @State var appearYet = false

    init(winStatus humanWinStatus: Binding<WinningType>, showModal isShowModal: Binding<Bool>, screenWidth: CGFloat, screenHeight: CGFloat) {
        self._humanWinStatus = humanWinStatus
        self._isShowModal = isShowModal
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

        let arr = contentModel.displayComputerMove(mode: playMode, itemPositions: itemPositions)
//        self.botVm.points.append(contentsOf: arr)
        if arr.count == 1 {
//            self.botVm.points.append(contentsOf: arr)
            self.botVm.startPoint = arr[0]
        }
        else {
            for i in 0..<arr.count {
//                self.botVm.points.append(arr[i])
                self.botVm.startPoint = arr[i]
                self.botVm.ignorePoints.append(arr[i])
            }
        }
        isHumanMove = false
        self.vm.startPoint = itemPositions[contentModel.currentIndex.row][contentModel.currentIndex.col]


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
                                            .opacity(appearYet ? 0.45 : 0.0)
                                    }
                                    Circle()
                                        .frame(width: circleSize, height: circleSize)
                                        .opacity(appearYet ? (checkIgnoreIndex || checkBouncingIndex ? 0.01 : 0.3) : 0.0)
                                        .onAppear(perform: {

                                        itemPositions[i][j] = CGPoint(
                                            x: offsetX + CGFloat(j) * (spacingGrid + circleSize),
                                            //                                            x: offsetX,
                                            y: offsetY + CGFloat(i) * (spacingGrid + circleSize)
                                        )
                                        // if start position
                                        if i == contentModel.totalRows / 2 && j == contentModel.totalColumns / 2 {
                                            self.vm.startPoint = itemPositions[i][j]
                                            self.startHuman = itemPositions[i][j]

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
                                                // add movement
                                                print("-------------------------------")
                                                let oldIndex = self.contentModel.currentIndex

                                                contentModel.defineHumanMovement(itemPositions: itemPositions, dragValue: value)
                                                let newIndex = self.contentModel.currentIndex

                                                // check if moving -> add animation
                                                if !oldIndex.equals(newIndex) {

                                                    if self.vm.points.count != self.vm.ignorePoints.count || self.vm.points.count == 0 {
                                                        self.vm.points.append([])
                                                    }
                                                    self.vm.points[self.vm.points.count - 1].append(itemPositions[contentModel.currentIndex.row][contentModel.currentIndex.col])
                                                    self.vm.startPoint = itemPositions[contentModel.currentIndex.row][contentModel.currentIndex.col]
                                                    isHumanMove = true
                                                }
                                                if contentModel.humanMoveValid {
                                                    isDisableBoard = true

                                                    Task {
                                                        // check winning
                                                        await checkInMatchWin()
                                                        if contentModel.humanWinStatus != .none {
                                                            return
                                                        }
                                                        // prevent display draw after display winning
                                                        if humanWinStatus != .none {
                                                            isDisableBoard = false
                                                            return
                                                        }
                                                        isBotMove = true
                                                        if (Int(startBot.x) == 0 && Int(startBot.y) == 0) {
                                                            startBot = self.vm.startPoint
                                                        }
                                                        self.botVm.startPoint = self.vm.startPoint
                                                        print("Start bot: ", startBot)
                                                        print("Start bot point: ", self.botVm.startPoint)
                                                        self.botVm.ignorePoints.append(self.vm.startPoint)

                                                        await computerMoveTurn()

                                                        self.vm.ignorePoints.append(itemPositions[contentModel.currentIndex.row][contentModel.currentIndex.col])

                                                        // check winning
                                                        await checkInMatchWin()
                                                        if contentModel.humanWinStatus != .none {
                                                            return
                                                        }
                                                    }

                                                }
                                            }
                                        }
                                    )                                }
                            }
                        }

                    }
                }
                    .disabled(isDisableBoard)

//                Route(points: self.vm.points, head: self.vm.lastPoint)
                contentModel.botPath.stroke(Color.blue, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                contentModel.humanPath.stroke(Color.red, style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
//                Route(points: self.vm.points, ignorePoints: self.vm.ignorePoints, start: startHuman, startPoint: self.vm.startPoint, isPlayerMove: isHumanMove)
//                    .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .miter, miterLimit: 0, dash: [], dashPhase: 0))
//                    .foregroundColor(.red)
//                    .animation(.easeInOut(duration: 0.3), value: 1)
//                Route(points: self.botVm.points, ignorePoints: self.botVm.ignorePoints, start: startBot, startPoint: self.botVm.startPoint, isPlayerMove: isBotMove)
//                    .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .miter, miterLimit: 0, dash: [], dashPhase: 0))
//                    .foregroundColor(.blue)
//                    .animation(.easeInOut(duration: 0.3), value: 1)


            }
            .animation(
                Animation.easeInOut(duration: duration + 0.5), value: appearYet
            )
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                        appearYet.toggle()
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

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(winStatus: .constant(WinningType.none), showModal: .constant(false), screenWidth: 350, screenHeight: 300)
    }
}
