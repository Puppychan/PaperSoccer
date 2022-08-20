//
//  ViewUltility.swift
//  PlayNow
//
//  Created by Nhung Tran on 18/08/2022.
// https://stackoverflow.com/questions/57467353/conditional-property-in-swiftui

import Foundation
import SwiftUI

struct ModelUtility {
    static func randomUsername() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<Int.random(in: 3...7)).map { _ in letters.randomElement()! })
    }
    
    // find direction
    
}
