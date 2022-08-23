//
//  GameContentModel.swift
//  PaperSoccer
//
//  Created by Nhung Tran on 21/08/2022.
//

import Foundation
import SwiftUI
class GameContentModel: ObservableObject {
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    let totalCountItems = 35
    
    var ignoreRanges: [ClosedRange<Int>]
    var totalColumns: Int
    var totalRowNum: Int
    var startFinalRowIndex: Int
    var endLeftIndex: Int
    var startRightIndex: Int
    
    var currentIndex: Int
    var currentHumanIndex: Int = 0
    var currentBotIndex: Int = 0
    
    @Published var moves: [Move?]
    @Published var dragDirection: DragDirection = .none
    @Published var humanPath = Path()
    @Published var botPath = Path()
    // add can continue moving later
    @Published var canContinueMoving: Bool = false
    
    @Published var humanMoveValid = false
    
    init() {
        self.moves = Array(repeating: nil, count: self.totalCountItems)
        
        self.totalColumns = columns.count
        self.totalRowNum = self.totalCountItems / self.totalColumns
        self.currentIndex = self.totalCountItems / 2
        
        self.startFinalRowIndex = self.totalColumns * (self.totalRowNum - 1)
        self.endLeftIndex = (self.totalColumns / 2) - 1
        self.startRightIndex = (self.totalColumns / 2) + 1
        let endLeftRange = self.endLeftIndex - 1
        let startRightRange = self.startRightIndex + 1
        
        self.ignoreRanges = [
            0...endLeftRange,
            startRightRange...self.totalColumns - 1,
            self.startFinalRowIndex...(endLeftRange + self.startFinalRowIndex),
            self.startFinalRowIndex + startRightRange...self.totalColumns - 1 + self.startFinalRowIndex
        ]
        
        // set center or starting point already occupy
        assignMove(currentIndex: self.currentIndex, for: self.totalCountItems / 2)
    }
    
    // MARK: - movement
    // MARK: assign move to array
    func assignMove(currentIndex: Int, for newIndex: Int) {
        if self.moves[newIndex] != nil {
            //            self.moves[newIndex]?.isOccupy = true
            self.moves[newIndex]?.occupyDirection.append(currentIndex)
        }
        else {
            self.moves[newIndex] = Move(isOccupy: true, occupyDirection: [currentIndex])
        }
    }
    
    // MARK: check ignore shapes or ignore positions
    func checkInRanges(for index: Int) -> Bool {
        for range in ignoreRanges {
            if range ~= index {
                return true
            }
        }
        return false
    }
    func isIgnorePosition(for index: Int) -> Bool {
        return ((index < self.totalColumns || index >= self.startFinalRowIndex) &&
                checkInRanges(for: index))
    }
    
    // MARK: Bouncing index movement check
    func isBouncingDragValid(for currentIndex: Int) -> Int {
        // 1: index is not bouncing
        // -1: index is bouncing but drag direction is invalid
        // 0: index is bouncing and drag direction is valid
        // up
        if (checkInRanges(for: currentIndex - self.totalColumns)) {
            if (self.dragDirection == .north ||
                self.dragDirection == .northwest ||
                self.dragDirection == .northeast ||
                self.dragDirection == .east ||
                self.dragDirection == .west) {
                            print("Bouncing Up", currentIndex)
                return -1
            }
            return 0
        }
        
        // down
        else if (checkInRanges(for: currentIndex + self.totalColumns)) {
            if (self.dragDirection == .south ||
             self.dragDirection == .southwest ||
             self.dragDirection == .southeast ||
             self.dragDirection == .east ||
             self.dragDirection == .west) {
                            print("Bouncing Down", currentIndex)
                return -1
            }
            return 0
        }
        
        // left
        else if (currentIndex % self.totalColumns == 0) {
            if (self.dragDirection == .west ||
             self.dragDirection == .northwest ||
             self.dragDirection == .southwest ||
             self.dragDirection == .north ||
             self.dragDirection == .south) {
                            print("Bouncing Left", currentIndex)
                return -1 }
            return 0
        }
        
        // right
        else if ((currentIndex + 1) % self.totalColumns == 0) {
            if (self.dragDirection == .east ||
             self.dragDirection == .northeast ||
             self.dragDirection == .southeast ||
             self.dragDirection == .north ||
             self.dragDirection == .south) {
                            print("Bouncing Right", currentIndex)
                return -1
            }
            return 0
        }
        // special left: the goal
        else if (
            currentIndex == self.endLeftIndex + self.totalColumns) {
            if (self.dragDirection == .west ||
             self.dragDirection == .northwest ||
             self.dragDirection == .north) {
                            print("Bouncing Special Left", currentIndex)
                return -1
            }
            return 0
        }
        // special right: the goal
        else if (currentIndex == self.startRightIndex + self.totalColumns) {
            if (self.dragDirection == .east ||
             self.dragDirection == .northeast ||
             self.dragDirection == .north) {
                            print("Bouncing Special Right", currentIndex)
                return -1
            }
            return 0
        }
        return 1
    }
    
    func isContinueMoving(for newIndex: Int) -> Bool {
        if self.moves[newIndex] != nil {
            print("moves: true")
            // already move
            if (self.moves[self.currentIndex]?.occupyDirection.contains(newIndex) ?? true) {
                return false
            }
            
            // if not already move check other thing
            return !(self.moves[newIndex]?.occupyDirection.contains(self.currentIndex) ?? true)
        }
        return false
    }
    
    func checkValidIndex(for newIndex: Int) -> Bool {
        if newIndex < self.totalCountItems {// check if can continue moving after first moving
            self.canContinueMoving = isContinueMoving(for: newIndex)
            
        }
        // for simple rule
        //        print("Out of bound check:", 0..<self.totalCountItems ~= newIndex)
        //        print("Inside ignore region check:", !isIgnorePosition(for: newIndex))
        //        print("Is bouncing if inside wall: ", isBouncingDragValid(for: self.currentIndex))
        //        print("Is nil moves: ", self.moves[newIndex] == nil, "- continue moving:", self.canContinueMoving)
        //        print("None drag: ", newIndex != self.currentIndex)
        return (0..<self.totalCountItems ~= newIndex) &&
        !isIgnorePosition(for: newIndex) &&
        isBouncingDragValid(for: self.currentIndex) != -1 &&
        (self.moves[newIndex] == nil || self.canContinueMoving) &&
        newIndex != self.currentIndex
    }
    
    // MARK: Identify next position after user drag
    func identifyNextMovementDrag() -> Int {
        // identify simple steps (rule only)
        var newIndex = self.currentIndex
        switch self.dragDirection {
        case .north:
            newIndex -= self.totalColumns
        case .east:
            newIndex += 1
        case .west:
            newIndex -= 1
        case .south:
            newIndex += self.totalColumns
        case .northeast:
            newIndex -= (self.totalColumns - 1)
        case .northwest:
            newIndex -= (self.totalColumns + 1)
        case .southeast:
            newIndex += (self.totalColumns + 1)
        case .southwest:
            newIndex += (self.totalColumns - 1)
        case .none:
            newIndex = currentIndex
        }
        
        return newIndex
    }
    
    // MARK: add movement
    func defineHumanMovement(itemPositions: [CGPoint], dragValue: DragGesture.Value) {
        // move to current position
        self.humanPath.move(to: itemPositions[self.currentIndex])
        var newIndex: Int
        // add animation ignore these directions later
        // find drag direction
        self.dragDirection = ModelUtility.findDragDirection(startLocation: dragValue.startLocation, location: dragValue.location)
        
        newIndex = identifyNextMovementDrag()
        
        // start drawing path
        
        // if movement valid
        if checkValidIndex(for: newIndex) {
            
            print("Human valid: ", currentIndex, newIndex)
            
            // assign movement to moves
            assignMove(currentIndex: self.currentIndex, for: newIndex)
            assignMove(currentIndex: newIndex, for: self.currentIndex)
            print(newIndex ,": ",self.moves[newIndex]?.occupyDirection ?? [])
            print(self.currentIndex ,": ",self.moves[self.currentIndex]?.occupyDirection ?? [])
            
            // assign current index ot new index + add line
            self.currentIndex = newIndex
            self.humanPath.addLine(to: itemPositions[self.currentIndex])
            
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
    
    // MARK: determine computer moving position
    func findComputerMove(itemPositions: [CGPoint]) {
        print("----------------- Comp")
        // move to current position
        self.botPath.move(to: itemPositions[self.currentIndex])
        
        var newIndex: Int
        self.canContinueMoving = true
        
        while self.canContinueMoving {
            // repeat until drag direction and index is valid
            repeat {
                self.dragDirection = DragDirection.allCases.randomElement() ?? .none
                newIndex = identifyNextMovementDrag()
                if checkValidIndex(for: newIndex) {
                    break
                }
                else {
                    self.dragDirection = .none
                }
                print("Comp: ", currentIndex, newIndex)
            } while self.dragDirection == .none
            
            // assign movement to moves
            assignMove(currentIndex: self.currentIndex, for: newIndex)
            assignMove(currentIndex: newIndex, for: self.currentIndex)
            print(newIndex ,": ", self.moves[newIndex]?.occupyDirection ?? [])
            print(self.currentIndex ,": ",self.moves[self.currentIndex]?.occupyDirection ?? [])
            
            print("Comp valid: ", currentIndex, newIndex)
            
            self.currentIndex = newIndex
            
            // check if bouncing -> continue move
            self.dragDirection = .none
            if isBouncingDragValid(for: self.currentIndex) == 0 {
                self.canContinueMoving = true
            }
            
            self.botPath.addLine(to: itemPositions[self.currentIndex])
        }
        
    }
    
    // MARK: - Winning status
    func checkWinning() -> WinningType {
        let a = 10
        if self.currentIndex == (self.totalColumns / 2) {
            // human win
            return .humanWin
        }
        else if self.currentIndex == (self.totalCountItems - 1 - self.totalColumns / 2) {
            // computer win
            return .computerWin
        }
        // logic tạm thời
        else if a == 100 {
            // draw
            return .draw
        }
        // no win yet
        else {
            return .none
        }
    }
}
