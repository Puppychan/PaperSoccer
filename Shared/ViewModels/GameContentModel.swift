/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2022B
  Assessment: Assignment 2
  Author: Tran Mai Nhung
  ID: s3879954
  Created  date: 15/08/2022
  Last modified: 29/08/2022
  Acknowledgement: Tom Huynh github, canvas https://www.geeksforgeeks.org/minimax-algorithm-in-game-theory-set-3-tic-tac-toe-ai-finding-optimal-move/
*/
// Draw condition add later
//

import Foundation
import SwiftUI
class GameContentModel: ObservableObject {
    // grid columns and rows
    var totalColumns = 7
    var totalRows = 7

    var totalCountItems: Int
    var endLeftIndex: Int
    var startRightIndex: Int
    var humanWinStatus: WinningType

    var currentIndex: Position
    var map: [[Move?]]

    var botTempMoves: [Position]

    @Published var dragDirection: DragDirection
    @Published var humanPath: Path
    @Published var botPath: Path
    @Published var isBotPlay: Bool
    // add can continue moving later
    @Published var canContinueMoving: Bool = false
    @Published var isDraw: Bool
    @Published var humanMoveValid: Bool
    
    @Published var humanStart: CGPoint

    init() {
        print("Init")
        self.totalCountItems = totalColumns * totalRows
        self.currentIndex = Position(self.totalRows / 2, self.totalColumns / 2)

        // for ignore positions
        self.endLeftIndex = (self.totalColumns / 2) - 1
        self.startRightIndex = (self.totalColumns / 2) + 1

        self.currentIndex = Position(self.totalRows / 2, self.totalColumns / 2)

        self.humanPath = Path()
        self.botPath = Path()

        self.map = [[Move?]](repeating: [Move?](repeating: nil, count: self.totalColumns), count: self.totalRows)

        self.humanWinStatus = .none

        // create move object for initial starting point
        self.isBotPlay = false
        self.botTempMoves = []
        self.humanMoveValid = false
        self.isDraw = false

        self.dragDirection = .none
        
        humanStart = CGPoint(x: 0, y: 0)
    }

    // MARK: - reset game
    func resetGame(itemsPosition: [[CGPoint]]) {
//        print("Reset")
        self.currentIndex = Position(self.totalRows / 2, self.totalColumns / 2)

        self.humanPath = Path()
        self.botPath = Path()
        ModelUtility.moveCurrentPath(on: &self.humanPath, itemsPosition[self.currentIndex.row][self.currentIndex.col], currentPosition: &self.humanStart)

        self.map = [[Move?]](repeating: [Move?](repeating: nil, count: self.totalColumns), count: self.totalRows)

        self.humanWinStatus = .none

        // create move object for initial starting point
        self.isBotPlay = false
        self.botTempMoves = []
        self.humanMoveValid = false
        self.isDraw = false

        self.dragDirection = .none
    }


    // MARK: - sound during game
    func playKickBallSound() {
        SoundModel.playSound(sound: "football-kick", type: "mp3")
    }

    // MARK: - assign move
    func assignMove(currentPosition: Position, for newPosition: Position) {
        let newRow = newPosition.row, newCol = newPosition.col

        if self.map[newRow][newCol] != nil {
            self.map[newRow][newCol]?.occupyDirection.append(currentPosition)
        }
        else {
            self.map[newRow][newCol] = Move(currentIsBot: isBotPlay, isOccupy: true, occupyDirection: [currentPosition], scores: 0, position: Position(newRow, newCol))
        }
    }

    // MARK: - validate index
    // MARK: check ignore shapes or ignore positions
    func isIgnorePosition(forRow currentRow: Int, forCol currentCol: Int) -> Bool {
        if currentRow == 0 || currentRow == self.totalRows - 1 {
            if ((0...self.endLeftIndex - 1) ~= currentCol) ||
                ((startRightIndex + 1)...(self.totalColumns - 1) ~= currentCol) {
                return true
            }
        }
        return false
    }

    // MARK: check if index is out of bound
    func isNotOutOfBoundIndex(for position: Position) -> Bool {
        if (0..<self.totalRows ~= position.row && 0..<self.totalColumns ~= position.col) {
            return true
        }
        return false
    }

    // MARK: Bouncing index movement check
    func isBorderIndex(forX currentCol: Int, forY currentRow: Int) -> Bool {
        if ((currentCol == 0 || currentCol == self.totalColumns - 1 || currentRow == 0 || currentRow == self.totalRows - 1) &&
                !isIgnorePosition(forRow: currentRow, forCol: currentCol)) ||
            (isIgnorePosition(forRow: currentRow - 1, forCol: currentCol)) ||
            isIgnorePosition(forRow: currentRow + 1, forCol: currentCol) ||
            ((currentRow == 1 || currentRow == self.totalRows - 2) &&
                    (currentCol == self.endLeftIndex || currentCol == self.startRightIndex)) {
            return true
        }
        return false

    }
    
    // MARK: check if bouncing drag valid based on current index, next move index or current drag direction
    func isBouncingDragValid(for currentPosition: Position, new newPosition: Position = Position(-1, -1)) -> Int {
        // 1: index is not bouncing
        // -1: index is bouncing but drag direction is invalid
        // 0: index is bouncing and drag direction is valid

        let currentRow = currentPosition.row, currentCol = currentPosition.col

        // Bouncing left
        if (currentCol == 0) {
            // dead point no way out (left)
            if (currentRow == 1 || currentRow == self.totalRows - 2) &&
                (self.dragDirection == .east ||
                        (isNotOutOfBoundIndex(for: newPosition) && currentPosition.isMovingEast(new: newPosition))) {
                print("Bouncing Left Corner", currentRow, currentCol)
                return -1
            }

            // invalid direction when bouncing
            if ((self.dragDirection == .west ||
                    self.dragDirection == .northwest ||
                    self.dragDirection == .southwest ||
                    self.dragDirection == .north ||
                    self.dragDirection == .south)) ||
                (isNotOutOfBoundIndex(for: newPosition) && (currentPosition.isMovingWest(new: newPosition) ||
                            currentPosition.isMovingNorthWest(new: newPosition) ||
                            currentPosition.isMovingSouthWest(new: newPosition) ||
                            currentPosition.isMovingSouth(new: newPosition) ||
                            currentPosition.isMovingNorth(new: newPosition))) {

                print("Bouncing Left", currentRow, currentCol)
                return -1

            }
            return 0
        }

        // bouncing right
            else if (currentCol == self.totalColumns - 1) {
            // dead point no way out (right)
            if (currentRow == 1 || currentRow == self.totalRows - 2) &&
                (self.dragDirection == .west ||
                        (isNotOutOfBoundIndex(for: newPosition) && currentPosition.isMovingWest(new: newPosition))) {
                print("Bouncing Right Corner", currentRow, currentCol)
                return -1
            }

            // invalid direction when bouncing
            if (self.dragDirection == .east ||
                    self.dragDirection == .northeast ||
                    self.dragDirection == .southeast ||
                    self.dragDirection == .north ||
                    self.dragDirection == .south) ||
                (isNotOutOfBoundIndex(for: newPosition) && (currentPosition.isMovingEast(new: newPosition) ||
                            currentPosition.isMovingNorthEast(new: newPosition) ||
                            currentPosition.isMovingSouthEast(new: newPosition) ||
                            currentPosition.isMovingSouth(new: newPosition) ||
                            currentPosition.isMovingNorth(new: newPosition))) {
                print("Bouncing Right No Move", currentRow, currentCol, newPosition.row, newPosition.col)
                return -1
            }
            print("Bouncing Right", currentRow, currentCol)
            return 0
        }

        // bouncing up (ignore middle)
            else if (isIgnorePosition(forRow: currentRow - 1, forCol: currentCol)) {
            if (self.dragDirection == .north ||
                    self.dragDirection == .northwest ||
                    self.dragDirection == .northeast ||
                    self.dragDirection == .east ||
                    self.dragDirection == .west) ||
                (isNotOutOfBoundIndex(for: newPosition) && (currentPosition.isMovingEast(new: newPosition) ||
                            currentPosition.isMovingNorthEast(new: newPosition) ||
                            currentPosition.isMovingNorthWest(new: newPosition) ||
                            currentPosition.isMovingWest(new: newPosition) ||
                            currentPosition.isMovingNorth(new: newPosition))) {
                print("Bouncing Up No Move", currentRow, currentCol)
                return -1
            }
            print("Bouncing Up", currentRow, currentCol)
            return 0
        }

        // bouncing down (ignore middle)
            else if (isIgnorePosition(forRow: currentRow + 1, forCol: currentCol)) {
            if (self.dragDirection == .south ||
                    self.dragDirection == .southwest ||
                    self.dragDirection == .southeast ||
                    self.dragDirection == .east ||
                    self.dragDirection == .west) ||
                (isNotOutOfBoundIndex(for: newPosition) && (currentPosition.isMovingEast(new: newPosition) ||
                            currentPosition.isMovingSouthEast(new: newPosition) ||
                            currentPosition.isMovingSouthWest(new: newPosition) ||
                            currentPosition.isMovingWest(new: newPosition) ||
                            currentPosition.isMovingSouth(new: newPosition))) {
                print("Bouncing Down", currentRow, currentCol)
                return -1
            }
            print("Bouncing Dowqn", currentRow, currentCol)
            return 0
        }

        // bouncing special left up: near the goal
            else if (currentRow == 1) &&
            currentCol == self.endLeftIndex {

            if (self.dragDirection == .west ||
                    self.dragDirection == .northwest ||
                    self.dragDirection == .north) ||
                (isNotOutOfBoundIndex(for: newPosition) && (
                        currentPosition.isMovingNorthWest(new: newPosition) ||
                            currentPosition.isMovingWest(new: newPosition) ||
                            currentPosition.isMovingNorth(new: newPosition))) {
                print("Bouncing Special Left", currentRow, currentCol)
                return -1
            }

            print("Bouncing Special Up ", currentRow, currentCol)
            return 0
        }
        // bouncing special right up: near the goal
            else if (currentRow == 1) &&
            currentCol == self.startRightIndex {
            if (self.dragDirection == .east ||
                    self.dragDirection == .northeast ||
                    self.dragDirection == .north) ||
                (isNotOutOfBoundIndex(for: newPosition) && (currentPosition.isMovingEast(new: newPosition) ||
                            currentPosition.isMovingNorthEast(new: newPosition) ||
                            currentPosition.isMovingNorth(new: newPosition))) {
                print("Bouncing Special Right", currentRow, currentCol)
                return -1
            }
            return 0
        }

        // bouncing special left down: near the goal
            else if (currentRow == self.totalRows - 2) &&
            currentCol == self.endLeftIndex {

            if (self.dragDirection == .west ||
                    self.dragDirection == .southwest ||
                    self.dragDirection == .south) ||
                (isNotOutOfBoundIndex(for: newPosition) && (currentPosition.isMovingWest(new: newPosition) ||
                            currentPosition.isMovingSouthWest(new: newPosition) ||
                            currentPosition.isMovingSouth(new: newPosition))) {
                print("Bouncing Special Down Left", currentRow, currentCol)
                return -1
            }

            return 0
        }
        // bouncing special right up: near the goal
            else if (currentRow == self.totalRows - 2) &&
            currentCol == self.startRightIndex {
            if (self.dragDirection == .east ||
                    self.dragDirection == .southeast ||
                    self.dragDirection == .south) ||
                (isNotOutOfBoundIndex(for: newPosition) && (currentPosition.isMovingEast(new: newPosition) ||
                            currentPosition.isMovingSouthEast(new: newPosition) ||
                            currentPosition.isMovingSouth(new: newPosition))) {
                print("Bouncing Special Down Right", currentRow, currentCol)
                return -1
            }
            return 0
        }
        return 1
    }

    // MARK: - validate movement
    // check again
    func isContinueMoving(for currentPosition: Position) -> Bool {
        // out of range fix

        let row = currentPosition.row, col = currentPosition.col
        if self.map[row][col] != nil {
            // already move
            if (self.map[row][col]?.occupyDirection.contains(where: { $0.equals(currentPosition) }) ?? true) {
                return false
            }

            // if not already move check other thing
            return !(self.map[row][col]?.occupyDirection.contains(where: { $0 == self.currentIndex }) ?? true)
        }
        return false
    }

    // MARK: - Movement
    // MARK: validate new index before movement
    func checkValidIndex(for newPosition: Position) -> Bool {
        let row = newPosition.row, col = newPosition.col
        if !(0..<self.totalRows ~= row && 0..<self.totalColumns ~= col) {
            return false
        }

        self.canContinueMoving = isContinueMoving(for: newPosition)

        // for simple rule
        // check 1 3 later
        // check starting point: center
//                print("Out of bound check:", 0..<self.totalRows ~= row && 0..<self.totalColumns ~= col)
//                print("Inside ignore region check:", !isIgnorePosition(forRow: row, forCol: col))
//                print("Is bouncing if inside wall: ",  isBouncingDragValid(for: self.currentIndex))
//                print("Is nil moves: ", self.map[row][col] == nil, "- continue moving:", self.canContinueMoving)
//                print("None drag: ",!newPosition.equals(self.currentIndex))
        return isNotOutOfBoundIndex(for: newPosition) &&
            !isIgnorePosition(forRow: row, forCol: col) &&
        (isBouncingDragValid(for: self.currentIndex, new: newPosition) != -1) &&
            (self.map[row][col] == nil || self.canContinueMoving) &&
            !newPosition.equals(self.currentIndex)
    }

    // MARK: Identify next position after user drag
    func identifyNextMovementDrag(dragDirection: DragDirection) -> Position {

        // identify simple steps (rule only)
        var newRow = self.currentIndex.row
        var newCol = self.currentIndex.col

        switch dragDirection {
        case .north:
            newRow -= 1
        case .east:
            newCol += 1
        case .west:
            newCol -= 1
        case .south:
            newRow += 1
        case .northeast:
            newRow -= 1
            newCol += 1
        case .northwest:
            newRow -= 1
            newCol -= 1
        case .southeast:
            newRow += 1
            newCol += 1
        case .southwest:
            newRow += 1
            newCol -= 1
        case .none:
            newRow = self.currentIndex.row
            newCol = self.currentIndex.col
        }

        return Position(newRow, newCol)
    }
    
//    // MARK: check if dead corners
//    func isDeadCorners(pos: Position) -> Bool {
//        let col = pos.col, row = pos.row
//        if (pos.col == 0 || pos.row)
//    }
    
    // MARK: check draw movement
    func checkDrawMovement(currentPosition: Position) {
        var countCannotMove = 0
        let currentRow = currentPosition.row, currentCol = currentPosition.col
        for i in (currentRow - 1)...(currentRow + 1) {
            for j in (currentCol - 1)...(currentCol + 1) {
                // if is current index -> skip
                if i == currentRow && j == currentCol {
                    continue
                }
                
                let newPosition = Position(i, j)
                
                print("Out of bound check:", 0..<self.totalRows ~= i && 0..<self.totalColumns ~= j)
                print("Inside ignore region check:", !isIgnorePosition(forRow: i, forCol: j))
                print("Is bouncing if inside wall: ",  isBouncingDragValid(for: currentPosition, new: newPosition))
                if i < self.totalRows && j < self.totalColumns {
                    print("Is nil moves: ", self.map[i][j] == nil, "- continue moving:", isContinueMoving(for: newPosition))
                }
                print("None drag: ",!newPosition.equals(currentPosition))
                
                // check draw condition
                if !(isNotOutOfBoundIndex(for: newPosition) &&
                     !isIgnorePosition(forRow: i, forCol: j) &&
                     (self.map[i][j] == nil || isContinueMoving(for: newPosition))
                     && (isBouncingDragValid(for: currentPosition, new: newPosition) != -1) ) {
                    print(i, j)
                    countCannotMove += 1
                }
            }
        }
        
        // if all moves not valid -> draw
        if countCannotMove == 8 {
            self.isDraw = true
        }
    }
    
    // MARK: assign move to map
    func assignMovingMap(newPosition: Position) {
        assignMove(currentPosition: self.currentIndex, for: newPosition)
        assignMove(currentPosition: newPosition, for: self.currentIndex)
    }


    // MARK: - display human movements

    func defineHumanMovement(itemPositions: [[CGPoint]], dragValue: DragGesture.Value) {
        self.isBotPlay = false
        // move path to current posiiton
        ModelUtility.moveCurrentPath(on: &self.humanPath, itemPositions[self.currentIndex.row][self.currentIndex.col], currentPosition: &self.humanStart)


        self.dragDirection = ModelUtility.findDragDirection(startLocation: dragValue.startLocation, location: dragValue.location)
        let newPosition: Position = identifyNextMovementDrag(dragDirection: self.dragDirection)

        // if new movement valid -> display
        if (checkValidIndex(for: newPosition)) {
            print("Human valid: \(self.currentIndex.row), \(self.currentIndex.col) - New: \(newPosition.row), \(newPosition.col)")

            // assign movement to moves
            assignMovingMap(newPosition: newPosition)

            // assign current index ot new index + add line
            self.currentIndex = newPosition
            playKickBallSound()
            ModelUtility.drawMovingLine(on: &self.humanPath, itemPositions[self.currentIndex.row][self.currentIndex.col], currentPosition: &self.humanStart)
            

            // check winning
            self.dragDirection = .none
            checkDrawMovement(currentPosition: self.currentIndex)
            checkWinning()
            if self.humanWinStatus != .none {
                self.humanMoveValid = true
            }

            else {
                // check if bouncing -> continue move
                if isBouncingDragValid(for: self.currentIndex) == 0 {
                    self.canContinueMoving = true
                }

                // if cannnot continue -> stop
                if !self.canContinueMoving {
                    // mark point as moved
                    self.humanMoveValid = true
                }
            }

        }
    }

    // MARK: - display computer movements
    func computerActionAfterMove(itemPositions: [[CGPoint]], newPosition: Position?) {
        print("Comp valid: \(self.currentIndex.row), \(self.currentIndex.col) - New: \(newPosition!.row), \(newPosition!.col)")

        playKickBallSound()
        // assign movement to moves
        assignMovingMap(newPosition: newPosition!)

        // start drawing
        ModelUtility.drawMovingLine(on: &self.botPath, itemPositions[newPosition!.row][newPosition!.col], currentPosition: &self.humanStart)

        
        self.currentIndex = newPosition!
        checkWinning()
    }
    
    // MARK: easy mode
    func easyMove(itemPositions: [[CGPoint]]) -> [CGPoint] {
        print("----------------- Comp")
        var positions: [CGPoint] = []
        var newPosition: Position? = nil
        self.canContinueMoving = true
        self.isDraw = false
        var checkLayer = 0
        var directionSet: Set<Position> = []

        // move path to current posiiton
        ModelUtility.moveCurrentPath(on: &self.botPath, itemPositions[self.currentIndex.row][self.currentIndex.col], currentPosition: &self.humanStart)

        while self.canContinueMoving {
            repeat {
                // find next move index
                switch checkLayer {
                case 0:
                    if self.currentIndex.col <= endLeftIndex {
                        newPosition = Position(self.currentIndex.row + 1, self.currentIndex.col + 1)
                    }
                    else if self.currentIndex.col >= startRightIndex {
                        newPosition = Position(self.currentIndex.row + 1, self.currentIndex.col - 1)
                    }
                    else {
                        newPosition = Position(self.currentIndex.row + 1, self.currentIndex.col)
                    }
                case 1:
                    if self.currentIndex.col <= endLeftIndex || self.currentIndex.col >= startRightIndex {
                        newPosition = Position(self.currentIndex.row + 1, self.currentIndex.col)
                    }
                    else {
                        newPosition = Position(self.currentIndex.row + 1, self.currentIndex.col + (Bool.random() ? 1 : (-1)))
                    }
                default:
                    newPosition = Position(self.currentIndex.row + Int.random(in: -1...1), self.currentIndex.col + Int.random(in: -1...1))
                }
                
                // add to set
                directionSet.insert(newPosition!)
                checkLayer += 1
                
                // if valid
                if checkValidIndex(for: newPosition!) {
                    checkLayer = 0
                    directionSet = []
                    break
                }
                // check draw or winning
                else if directionSet.count == 8 {
                    checkWinning()
                    if self.humanWinStatus == .none {
                        checkLayer = 0
                        directionSet = []
                        self.isDraw = true
                        checkWinning()
                        break
                    }
                }
            } while true

            // validate index
            // Draw condition
            if self.isDraw {
                self.canContinueMoving = false
                break
            }
            
            // add action after moving
            computerActionAfterMove(itemPositions: itemPositions, newPosition: newPosition)
            positions.append(CGPoint(x: newPosition!.row, y: newPosition!.col))
            
            // if having human win status
            if self.humanWinStatus != .none {
                return positions
            }

            // check if bouncing -> continue move
            self.dragDirection = .none
            if isBouncingDragValid(for: newPosition!) == 0 {
                self.canContinueMoving = true
            }
        }
        return positions
    }
    
    // MARK: normal mode
    func normalMove(itemPositions: [[CGPoint]]) -> [CGPoint] {
        print("----------------- Comp Normal")
        var positions: [CGPoint] = []
        var newPosition: Position? = nil
        self.canContinueMoving = true
        self.isDraw = false
        var checkLayer = 0
        var directionSet: Set<Position> = []

        // move path to current posiiton
        ModelUtility.moveCurrentPath(on: &self.botPath, itemPositions[self.currentIndex.row][self.currentIndex.col], currentPosition: &self.humanStart)

        while self.canContinueMoving {
            repeat {
                // define next computer movement
                switch checkLayer {
                case 0:
                    if isBorderIndex(forX: self.currentIndex.col, forY: self.currentIndex.row) {
                        if self.currentIndex.col <= endLeftIndex {
                            newPosition = Position(self.currentIndex.row + 1, self.currentIndex.col + 1)
                        }
                        else {
                            newPosition = Position(self.currentIndex.row + 1, self.currentIndex.col - 1)
                        }
                    }
                    else {
                        if self.currentIndex.col.isMultiple(of: 2) ||
                            self.currentIndex.col == self.totalColumns / 2 {
                            newPosition = Position(self.currentIndex.row + 1, self.currentIndex.col)
                        }
                        else if self.currentIndex.col <= endLeftIndex {
                            newPosition = Position(self.currentIndex.row + 1, self.currentIndex.col - 1)
                        }
                        else if self.currentIndex.col >= startRightIndex {
                            newPosition = Position(self.currentIndex.row + 1, self.currentIndex.col + 1)
                        }
                        else {
                            newPosition = Position(self.currentIndex.row + 1, self.currentIndex.col + (Bool.random() ? 1 : (-1)))
                        }
                    }
                case 1:
                    if self.currentIndex.col <= endLeftIndex || self.currentIndex.col >= startRightIndex {
                        newPosition = Position(self.currentIndex.row + 1, self.currentIndex.col)
                    }
                    else {
                        newPosition = Position(self.currentIndex.row + 1, self.currentIndex.col + (Bool.random() ? 1 : (-1)))
                    }
                default:
                    newPosition = Position(self.currentIndex.row + Int.random(in: -1...1), self.currentIndex.col + Int.random(in: -1...1))
                }
                directionSet.insert(newPosition!)
                checkLayer += 1
                if checkValidIndex(for: newPosition!) {
                    checkLayer = 0
                    directionSet = []
                    break
                }
                // check draw or winning
                else if directionSet.count == 8 {
                    checkWinning()
                    if self.humanWinStatus == .none {
                        checkLayer = 0
                        directionSet = []
                        self.isDraw = true
                        checkWinning()
                        break
                    }
                }
            } while true

            // validate index
            // Draw condition
            if self.isDraw {
                self.canContinueMoving = false
                break
            }
            
            // display action after moving
            computerActionAfterMove(itemPositions: itemPositions, newPosition: newPosition)
            positions.append(CGPoint(x: newPosition!.row, y: newPosition!.col))
            // if final result detection
            if self.humanWinStatus != .none {
                return positions
            }

            // check if bouncing -> continue move
            self.dragDirection = .none
            if isBouncingDragValid(for: newPosition!) == 0 {
                self.canContinueMoving = true
            }
        }
        return positions
    }
    
    // MARK: hard mode
    func hardMove(itemPositions: [[CGPoint]]) -> [CGPoint] {
        print("----------------- Comp Hard")
        var positions: [CGPoint] = []
        var newPosition: Position? = nil
        self.canContinueMoving = true
        self.isDraw = false
        var checkLayer = 0
        var directionSet: Set<Position> = []

        // move path to current posiiton
        ModelUtility.moveCurrentPath(on: &self.botPath, itemPositions[self.currentIndex.row][self.currentIndex.col], currentPosition: &self.humanStart)

        while self.canContinueMoving {
            // detect next moving index
            repeat {
                switch checkLayer {
                case 0:
                    if isBorderIndex(forX: self.currentIndex.col, forY: self.currentIndex.row) {
                        if self.currentIndex.row == self.totalRows - 2 {
                            let newCol: Int
                            let newRow: Int
                            // check col
                            if self.currentIndex.col <= endLeftIndex {
                                newCol = self.currentIndex.col + 1
                            }
                            else {
                                newCol = self.currentIndex.col - 1
                            }
                            
                            if endLeftIndex...startRightIndex ~= self.currentIndex.col {
                                newRow = self.currentIndex.row + 1
                            }
                            else {
                                newRow = self.currentIndex.row - 1
                            }
                            
                            newPosition = Position(newRow, newCol)
                        }
                        else if self.currentIndex.col == 0 {
                            newPosition = Position(self.currentIndex.row + 1, self.currentIndex.col + 1)
                        }
                        else {
                            newPosition = Position(self.currentIndex.row + 1, self.currentIndex.col - 1)
                        }
                    }
                    else {
                        if self.currentIndex.col.isMultiple(of: 2) ||
                            self.currentIndex.col == self.totalColumns / 2 {
                            newPosition = Position(self.currentIndex.row + 1, self.currentIndex.col)
                        }
                        else if self.currentIndex.col <= endLeftIndex {
                            newPosition = Position(self.currentIndex.row + 1, self.currentIndex.col - 1)
                        }
                        else if self.currentIndex.col >= startRightIndex {
                            newPosition = Position(self.currentIndex.row + 1, self.currentIndex.col + 1)
                        }
                        else {
                            newPosition = Position(self.currentIndex.row + 1, self.currentIndex.col + (Bool.random() ? 1 : (-1)))
                        }
                    }
                case 1:
                    if self.currentIndex.col <= endLeftIndex || self.currentIndex.col >= startRightIndex {
                        newPosition = Position(self.currentIndex.row + 1, self.currentIndex.col)
                    }
                    else {
                        newPosition = Position(self.currentIndex.row + 1, self.currentIndex.col + (Bool.random() ? 1 : (-1)))
                    }
                default:
                    newPosition = Position(self.currentIndex.row + Int.random(in: -1...1), self.currentIndex.col + Int.random(in: -1...1))
                }
                directionSet.insert(newPosition!)
                checkLayer += 1
                if checkValidIndex(for: newPosition!) {
                    checkLayer = 0
                    directionSet = []
                    break
                }
                // check draw or winning
                else if directionSet.count == 8 {
                    checkWinning()
                    if self.humanWinStatus == .none {
                        checkLayer = 0
                        directionSet = []
                        self.isDraw = true
                        checkWinning()
                        break
                    }
                }
            } while true

            // validate index
            // Draw condition
            if self.isDraw {
                self.canContinueMoving = false
                return positions
            }
            
            computerActionAfterMove(itemPositions: itemPositions, newPosition: newPosition)
            positions.append(CGPoint(x: newPosition!.row, y: newPosition!.col))
            
            if self.humanWinStatus != .none {
                return positions
            }

            // check if bouncing -> continue move
            self.dragDirection = .none
            if isBouncingDragValid(for: newPosition!) == 0 {
                self.canContinueMoving = true
            }
        }
        return positions
    }
    // even index if 2 sides no red -> move to center
    // bouncing up -> move to center
    // if center + next row is special bouncing -> move toward bouncing
    // if odd index next row is corner -> move other direction
    func displayComputerMove(mode: String, itemPositions: [[CGPoint]]) -> [CGPoint] {
        self.isBotPlay = true
        switch mode {
        case "easy":
            return easyMove(itemPositions: itemPositions)
        case "normal":
            return normalMove(itemPositions: itemPositions)
        case "hard":
            return hardMove(itemPositions: itemPositions)
        default:
            print("No mode")
            return []
        }
    }
    // MARK: - Winning status
    func checkWinning() {
        if self.endLeftIndex...self.startRightIndex ~= self.currentIndex.col {
            if self.currentIndex.row == 0 {
                // human win
                self.humanWinStatus = .humanWin
            }
            else if self.currentIndex.row == self.totalRows - 1 {
                // computer win
                self.humanWinStatus = .computerWin
            }
        }
        // logic tạm thời
            else if self.isDraw {
            // draw
            self.humanWinStatus = .draw
        }
        // not win yet
            else {
            self.humanWinStatus = .none
        }

    }


}
