//
//  GameContentModle.swift
//  PaperSoccer
//
//  Created by Nhung Tran on 25/08/2022.
// https://www.geeksforgeeks.org/minimax-algorithm-in-game-theory-set-3-tic-tac-toe-ai-finding-optimal-move/
// Draw condition add later
//

import Foundation
import SwiftUI
class GameContentModel: ObservableObject {
    var totalColumns = 7
    var totalRows = 7
    
    var totalCountItems: Int
    var endLeftIndex: Int
    var startRightIndex: Int
    var humanWinStatus: WinningType
    
    //    var currentIndex: Int
    //    var currentHumanIndex: Int = 0
    //    var currentBotIndex: Int = 0
    var currentIndex: Position
    var directionSet: Set<DragDirection>

    var map: [[Move?]]
    
    @Published var dragDirection: DragDirection = .none
    @Published var humanPath = Path()
    @Published var botPath = Path()
    @Published var isBotPlay: Bool
    // add can continue moving later
    @Published var canContinueMoving: Bool = false
    @Published var isDraw: Bool = false
    @Published var humanMoveValid = false
    
    init() {
        self.map = [[Move?]](repeating: [Move?](repeating: nil, count: self.totalColumns), count: self.totalRows)
        self.directionSet = []
        
        self.totalCountItems = totalColumns * totalRows
        self.currentIndex = Position(self.totalRows / 2, self.totalColumns / 2)
        
        // for ignore positions
        self.endLeftIndex = (self.totalColumns / 2) - 1
        self.startRightIndex = (self.totalColumns / 2) + 1
        
        self.humanWinStatus = .none
        
        // create move object for initial starting point
        self.isBotPlay = false
        assignMove(currentPosition: self.currentIndex, for: self.currentIndex)
        
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
    func isBouncingDragValid(for currentPosition: Position) -> Int {
        // 1: index is not bouncing
        // -1: index is bouncing but drag direction is invalid
        // 0: index is bouncing and drag direction is valid
        
        let currentRow = currentPosition.row, currentCol = currentPosition.col
        
        // Bouncing left
        if (currentCol == 0) {
            // dead point no way out (left)
            if (currentRow == 1 || currentRow == self.totalRows - 2) &&
                self.dragDirection == .east {
                print("Bouncing Left Corner", currentRow, currentCol)
                return -1
            }
            
            // invalid direction when bouncing
            if (self.dragDirection == .west ||
                self.dragDirection == .northwest ||
                self.dragDirection == .southwest ||
                self.dragDirection == .north ||
                self.dragDirection == .south) {
                
                print("Bouncing Left", currentRow, currentCol)
                return -1
                
            }
            return 0
        }
        
        // bouncing right
        else if (currentCol == self.totalColumns - 1) {
            // dead point no way out (right)
            if (currentRow == 1 || currentRow == self.totalRows - 2) &&
                self.dragDirection == .west {
                print("Bouncing Right Corner", currentRow, currentCol)
                return -1
            }
            
            // invalid direction when bouncing
            if (self.dragDirection == .east ||
                self.dragDirection == .northeast ||
                self.dragDirection == .southeast ||
                self.dragDirection == .north ||
                self.dragDirection == .south) {
                print("Bouncing Right No Move", currentRow, currentCol)
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
                self.dragDirection == .west) {
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
                self.dragDirection == .west) {
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
                self.dragDirection == .north) {
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
                self.dragDirection == .north) {
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
                self.dragDirection == .south) {
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
                self.dragDirection == .south) {
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
        return (0..<self.totalRows ~= row && 0..<self.totalColumns ~= col) &&
        !isIgnorePosition(forRow: row, forCol: col) &&
        isBouncingDragValid(for: self.currentIndex) != -1 &&
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
    
    func assignMovingMap(newPosition: Position) {
        assignMove(currentPosition: self.currentIndex, for: newPosition)
        assignMove(currentPosition: newPosition, for: self.currentIndex)
    }
    
    
    // MARK: - display human movements
    
    func defineHumanMovement(itemPositions: [[CGPoint]], dragValue: DragGesture.Value) {
        self.isBotPlay = false
        // move path to current posiiton
        ModelUtility.moveCurrentPath(on: &self.humanPath, itemPositions[self.currentIndex.row][self.currentIndex.col])
        
        
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
            ModelUtility.drawMovingLine(on: &self.humanPath, itemPositions[self.currentIndex.row][self.currentIndex.col])
            
            // check winning
            checkWinning()
            
            // check if bouncing -> continue move
            self.dragDirection = .none
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
    
    // MARK: - display computer movements
    func randomMove(itemPositions: [[CGPoint]]) -> [CGPoint] {
        print("----------------- Comp")
        var positions: [CGPoint] = []
        var newPosition: Position? = nil
        self.canContinueMoving = true
        self.isDraw = false
        
        // move path to current posiiton
        ModelUtility.moveCurrentPath(on: &self.botPath, itemPositions[self.currentIndex.row][self.currentIndex.col])
        
        while self.canContinueMoving {
            // repeat until drag direction and index is valid
            repeat {
                // find drag direction
                self.dragDirection = DragDirection.allCases.randomElement() ?? .none
                if self.dragDirection != .none {
                    if self.directionSet.insert(self.dragDirection).inserted {
                        // find new index based on drag direction
                        newPosition =
                        identifyNextMovementDrag(dragDirection: self.dragDirection)
                        
                        // check if valid -> exit loop
                        if checkValidIndex(for: newPosition!) {
                            // reset drag direction set
                            self.directionSet = []
                            print("Comp valid: \(self.currentIndex.row), \(self.currentIndex.col) - New: \(newPosition!.row), \(newPosition!.col)")
                            break
                        }
                        else {
                            self.dragDirection = .none
                        }
                        print("Comp: \(self.currentIndex.row), \(self.currentIndex.col) - New: \(newPosition!.row), \(newPosition!.col)")
                    }
                    
                    // draw when computer cannot find any suitabl directions
                    else if self.directionSet.count == 8 {
                        checkWinning()
                        if self.humanWinStatus == .none {
                            self.isDraw = true
                            checkWinning()
                        }
                        break
                    }
                    // invalid index -> drag direction none for continueing finding
                    else {
                        self.dragDirection = .none
                    }
                }
                
                
            } while self.dragDirection == .none
            
            // Draw condition
            if self.isDraw {
                self.canContinueMoving = false
                break
            }
            
            playKickBallSound()
            // assign movement to moves
            assignMovingMap(newPosition: newPosition!)
            
            // start drawing
            self.currentIndex = newPosition!
            positions.append(CGPoint(x: self.currentIndex.row, y: self.currentIndex.col))
            
            ModelUtility.drawMovingLine(on: &self.botPath, itemPositions[self.currentIndex.row][self.currentIndex.col])
            
            checkWinning()
            
            // check if bouncing -> continue move
            self.dragDirection = .none
            if isBouncingDragValid(for: self.currentIndex) == 0 {
                self.canContinueMoving = true
            }
            
        }
        return positions
    }

    
    func displayComputerMove(mode: String, itemPositions: [[CGPoint]]) -> [CGPoint] {
        self.isBotPlay = true
        switch mode {
        case "easy":
            return randomMove(itemPositions: itemPositions)
        case "hard":
            print("Hard")
            return []
        default:
            print("No mode")
            return []
        }
    }
    // MARK: - Winning status
    func checkWinning() {
        let a = 10
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
    
    // MARK: - reset game
    func resetGame() {
        SoundModel.playSound(sound: "game", type: "mp3")
        self.map = [[Move?]](repeating: [Move?](repeating: nil, count: self.totalColumns), count: self.totalRows)
    }
    
}
