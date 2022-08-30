/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2022B
 Assessment: Assignment 2
 Author: Tran Mai Nhung
 ID: s3879954
 Created  date: 15/08/2022
 Last modified: 29/08/2022
 Acknowledgement: Tom Huynh github, canvas
 // https://stackoverflow.com/questions/62602279/using-appstorage-for-string-map/62602643#62602643
 https://www.anycodings.com/1questions/552647/how-can-i-get-appstorage-to-work-in-an-mvvm-swiftui-framework
 */
import Foundation
import Combine
import SwiftUI

class SettingsManager: ObservableObject {
    // init
    static let shared = SettingsManager()
    
    // data
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
