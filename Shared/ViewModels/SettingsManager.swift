//
//  SettingsManager.swift
//  PaperSoccer
//
//  Created by Nhung Tran on 28/08/2022.
// https://www.anycodings.com/1questions/552647/how-can-i-get-appstorage-to-work-in-an-mvvm-swiftui-framework
import Foundation
import Combine
import SwiftUI

class SettingsManager: ObservableObject {
    static let shared = SettingsManager()
    
    @AppStorage("currentHuman") var currentHuman: Data = Data() {
        willSet { objectWillChange.send() }
    }
    
    @AppStorage("currentBot") var currentBot: Data = Data() {
        willSet { objectWillChange.send() }
    }
    

    // array
    @AppStorage("playerList") var players: Data = Data() {
        willSet { objectWillChange.send() }
    }
}
