//
//  Ultilities.swift
//  PaperSoccer
//
//  Created by Nhung Tran on 20/08/2022.
//

import Foundation
enum DragDirection: String, CaseIterable {
    case north = "top none", east = "none right", west = "none left", south = "bottom none", northeast = "top right", northwest = "top left", southeast = "bottom right", southwest = "bottom left", none = "none none"
}
enum WinningType: String {
    case humanWin = "human win"
    case computerWin = "computer win"
    case draw = "draw"
    case none = "none"
}
