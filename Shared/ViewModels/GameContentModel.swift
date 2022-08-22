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

    @Published var moves: [Int]
    @Published var dragDirection: DragDirection = .none
    @Published var humanPath = Path()
    @Published var botPath = Path()

    @Published var humanMoveValid = false

    init() {
        self.moves = Array(repeating: -1, count: totalCountItems)

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
        self.moves[self.totalCountItems / 2] = 1
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
    func isIgnorePosition(for index: Int) -> Bool {
        return ((index < self.totalColumns || index >= self.startFinalRowIndex) &&
                checkInRanges(for: index))
    }
    func isBouncingDragValid(for currentIndex: Int) -> Bool {
        // left
        if (currentIndex % self.totalColumns == 0 ||
                currentIndex == self.endLeftIndex) &&
            (self.dragDirection == .west ||
                    self.dragDirection == .northwest ||
                    self.dragDirection == .southwest ||
                    self.dragDirection == .north ||
                    self.dragDirection == .south) {
            return false
        }

        // right
        if ((currentIndex + 1) % self.totalColumns == 0 ||
                currentIndex == self.startRightIndex) &&
            (self.dragDirection == .east ||
                    self.dragDirection == .northeast ||
                    self.dragDirection == .southeast ||
                    self.dragDirection == .north ||
                    self.dragDirection == .south) {
            return false
        }
        return true
    }
    func checkValidIndex(for newIndex: Int) -> Bool {
        // for simple rule
        return ((0..<self.totalCountItems ~= newIndex) &&
                !isIgnorePosition(for: newIndex) &&
                isBouncingDragValid(for: self.currentIndex) &&
                self.moves[newIndex] != 1)
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
            print("Human valid: ", currentIndex, newIndex)
            print("Human:", moves[newIndex])
            self.currentIndex = newIndex
            self.humanPath.addLine(to: itemPositions[self.currentIndex])

            // mark point as moved
            self.humanMoveValid = true
            moves[self.currentIndex] = 1
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
                print("Comp valid: ", currentIndex, newIndex)
                print("Comp:", moves[newIndex])
                self.currentIndex = newIndex
                moves[self.currentIndex] = 1
                break
            }
            print("Comp: ", currentIndex, newIndex)
        }
        // if movement valid
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
