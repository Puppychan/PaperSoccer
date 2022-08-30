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
 // https://talk.objc.io/episodes/S01E244-detecting-taps
 // https://stackoverflow.com/questions/59109138/how-to-implement-a-left-or-right-draggesture-that-trigger-a-switch-case-in-swi
 // https://stackoverflow.com/questions/27517632/how-to-create-a-delay-in-swift
 // https://stackoverflow.com/questions/66748286/swiftui-create-a-animating-circle
 https://swiftontap.com/strokestyle
 */


import SwiftUI

// main view for playing game
struct GameView: View {
    // pass from other classes
    @Binding var humanWinStatus: WinningType
    @Binding var isShowModal: Bool
    //    @State var playMode: String = "hard"
    @Binding var playMode: String
    var screenWidth: CGFloat
    var screenHeight: CGFloat
    
    @EnvironmentObject var model: GameModel
    // prevent call multiple times
    @StateObject var contentModel: GameContentModel = GameContentModel()
    
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
    
    // detect human move
    @State var isHumanMove = true
    @State var isBotMove = false
    
    let duration = 1.0
    @State var appearYet = false
    
    @State var scale = 0.5
    @State var circleSizeAnnotation: CGFloat = 50
    
    // styling the moving strokes of human and bot
    let movingStrokeStyle = StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .miter, miterLimit: 0, dash: [], dashPhase: 0)
    
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
            contentModel.resetGame(itemsPosition: itemPositions)
        }
    }
    
    // display computer move
    private func computerMoveTurn() async {
        // make program stop 1 second so looks like d
        try? await Task.sleep(nanoseconds: UInt64(1 * Double(NSEC_PER_SEC)))
        isHumanMove = false
        
        // bot moving positions
        _ = contentModel.displayComputerMove(mode: playMode, itemPositions: itemPositions)
        
        self.contentModel.humanMoveValid = false
        isDisableBoard = false
    }
    
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                
                // MARK: draw the stadium
                StadiumView(contentModel: contentModel, offsetX: offsetX, offsetY: offsetY, spacingGrid: spacingGrid, circleSize: circleSize, duration: duration)
                LazyVStack(spacing: spacingGrid) {
                    
                    // MARK: draw grid and add functionality
                    ForEach(0..<contentModel.map.count) { i in
                        
                        HStack(spacing: spacingGrid) {
                            ForEach(0..<contentModel.map[0].count) { j in
                                let checkIgnoreIndex = contentModel.isIgnorePosition(forRow: i, forCol: j)
                                let checkBouncingIndex = contentModel.isBorderIndex(forX: j, forY: i)
                                
                                ZStack {
                                    // display circle in border
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
                                            // if start position -> init
                                            if i == contentModel.totalRows / 2 && j == contentModel.totalColumns / 2 {
                                                contentModel.humanStart = itemPositions[i][j]
                                            }
                                        })
                                        .onTapGesture(perform: {
                                            print(i, j)
                                        })
                                        .gesture(
                                            DragGesture(minimumDistance: 0, coordinateSpace: .global)
                                                .onEnded { value in
                                                    if !checkIgnoreIndex {
                                                        isHumanMove = true
                                                        // add movement
                                                        print("-------------------------------")
                                                        // define human movement after user dragging
                                                        contentModel.defineHumanMovement(itemPositions: itemPositions, dragValue: value)
                                                        
                                                        // if user cannot move anymore -> computer turn
                                                        if contentModel.humanMoveValid {
                                                            isDisableBoard = true
                                                            Task {
                                                                // check winning before let bot take turn
                                                                await checkInMatchWin()
                                                                
                                                                // prevent display draw after display winning
                                                                if humanWinStatus != .none {
                                                                    // prevent user move when computer is moving
                                                                    isDisableBoard = false
                                                                    return
                                                                }
                                                                
                                                                isHumanMove = false
                                                                isBotMove = true
                                                                
                                                                // computer move
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
                
                // drawing movements of computer and human
                contentModel.botPath.stroke(Color("Ball Bot Clr"), style: movingStrokeStyle)
                contentModel.humanPath.stroke(Color("Ball Human Clr"), style: movingStrokeStyle)
                
                // Annotation to announce who is moving now
                Circle()
                    .foregroundColor(Color("Ball \(isHumanMove ? "Human" : "Bot") Move Clr"))
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
                // stop program to make animation look cleaner
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                    appearYet.toggle()
                    circleSize = screenWidth / 18 // 20
                    circleSizeAnnotation = circleSize / 1.15
                }
                
                // init spacing grid and circle
                spacingGrid = screenHeight / 20
                circleSize = screenWidth / 18 // 20
                
                // init starting position of x and y
                offsetY = geo.frame(in: .local).midY - (CGFloat(contentModel.totalRows / 2) * (spacingGrid + circleSize))
                offsetX = geo.frame(in: .local).midX - (CGFloat(contentModel.totalColumns / 2) * (spacingGrid + circleSize))
                
                // init positions array
                itemPositions = [[CGPoint]](repeating: [CGPoint](repeating: CGPoint(x: 0, y: 0), count: contentModel.totalColumns), count: contentModel.totalRows)
                
            }
        }
    }
}
