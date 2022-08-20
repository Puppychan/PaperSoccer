//
//  GameContentModel.swift
//  PaperSoccer
//
//  Created by Nhung Tran on 21/08/2022.
//

import Foundation
class GameContentModel: ObservableObject {
    func identifyNextMovementDrag(dragDirection: DragDirection, totalColumns: Int, currentIndex: Int) -> Int {
        var newIndex = currentIndex
        switch dragDirection {
            case .north:
                newIndex -= totalColumns
            case .east:
                newIndex += 1
            case .west:
                newIndex -= 1
            case .south:
                newIndex += totalColumns
            case .northeast:
                newIndex -= (totalColumns - 1)
            case .northwest:
                newIndex -= (totalColumns + 1)
            case .southeast:
                newIndex += (totalColumns + 1)
            case .southwest:
                newIndex += (totalColumns - 1)
            case .none:
                newIndex = currentIndex
        }
        return newIndex
    }
}
