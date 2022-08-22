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

    var currentIndex: Int
    var currentHumanIndex: Int = 0
    var currentBotIndex: Int = 0

    @Published var moves: [Move?]
    @Published var dragDirection: DragDirection = .none
    @Published var humanPath = Path()
    @Published var botPath = Path()
    
    @Published var humanMoveValid = false

    init() {
        self.moves = Array(repeating: nil, count: totalCountItems)
        
        self.totalColumns = columns.count
        self.totalRowNum = self.totalCountItems / self.totalColumns
        self.currentIndex = self.totalCountItems / 2

        self.startFinalRowIndex = self.totalColumns * (self.totalRowNum - 1)
        
        let endLeftIndex = (self.totalColumns / 2) - 2
        let startRightIndex = (self.totalColumns / 2) + 2
        self.ignoreRanges = [0...endLeftIndex,
            startRightIndex...self.totalColumns - 1,
            self.startFinalRowIndex...(endLeftIndex + self.startFinalRowIndex),
            self.startFinalRowIndex + startRightIndex...self.totalColumns - 1 + self.startFinalRowIndex
        ]
    }

    // MARK: - movement
    // MARK: check ignore shapes or ignore positions
    func checkInRanges(for index: Int) -> Bool {

        for range in ignoreRanges {
            if range ~= index {
                return true
            }
        }
        return false
    }
    func checkIgnorePosition(for index: Int) -> Bool {
        return ((index < self.totalColumns || index >= self.startFinalRowIndex) &&
                checkInRanges(for: index))
    }
    func checkBouncingDrag(for newIndex: Int) -> Bool {
        if newIndex % self.totalColumns == 0 ||
            (newIndex + 1) % self.totalColumns == 0 {
            if self.dragDirection == .north || self.dragDirection == .south {
                return false
            }
        }
        return true
    }
    func checkValidIndex(for newIndex: Int) -> Bool {
        // for simple rule
        print(0..<self.totalCountItems ~= -4)
        return ((0..<self.totalCountItems ~= newIndex) && !checkIgnorePosition(for: newIndex))
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
    func defineMovement(itemPositions: [CGPoint], dragValue: DragGesture.Value) {
        // move to current position
        self.humanPath.move(to: itemPositions[self.currentIndex])
        // add animation ignore these directions later
        // find drag direction
        self.dragDirection = ModelUtility.findDragDirection(startLocation: dragValue.startLocation, location: dragValue.location)

        let newIndex = identifyNextMovementDrag()
        // start drawing path

        // if movement valid
        if checkValidIndex(for: newIndex) {
            print("Human: ", currentIndex, newIndex)

            self.currentIndex = newIndex
            self.humanPath.addLine(to: itemPositions[self.currentIndex])
            self.humanMoveValid = true
        }
    }

    // MARK: - determine computer moving position
    func findComputerMove(itemPositions: [CGPoint]) {
        // move to current position
        self.botPath.move(to: itemPositions[self.currentIndex])
        
        var newIndex = self.totalCountItems
        // find drag direction
        self.dragDirection = .none

        while self.dragDirection == .none {
            self.dragDirection = DragDirection.allCases.randomElement() ?? .none
            newIndex = identifyNextMovementDrag()
            if checkValidIndex(for: newIndex) {
                break
            }
            print("Comp: ", currentIndex, newIndex)
        }
        // if movement valid
        self.currentIndex = newIndex
        self.botPath.addLine(to: itemPositions[self.currentIndex])
        
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
