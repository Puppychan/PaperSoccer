//
//  GameModel.swift
//  PlayNow
//
//  Created by Nhung Tran on 17/08/2022.
// https://stackoverflow.com/questions/26845307/generate-random-alphanumeric-string-in-swift

import Foundation
import SwiftUI
class GameModel: ObservableObject {

    @Published var players = [Player]()

    @Published var currentBot: Player
    @Published var currentHuman: Player

    @Published var backToHome: Int?

    init() {
        
        self.currentBot = Player(username: "Bot", isHuman: false, currentScore: 0, totalScore: 0)
        self.currentHuman = Player(username: ModelUtility.randomUsername(), isHuman: true, currentScore: 0, totalScore: 0)
        players.append(contentsOf: [self.currentBot, self.currentHuman])
    }

    // MARK: - init


    // MARK: - Game only

    func resetGame() {


    }

    // MARK: - Update Player Info
    func findPlayerId(for id: UUID) -> Int {
        let currentPlayerIndex = players.firstIndex(where: {
            $0.id == id
        }) ?? 0
        return currentPlayerIndex
    }
    func sortPlayerInScore() {
        self.players = self.players.sorted(by: { $0.totalScore > $1.totalScore })
    }
    
    // update scores during match
    func updateScores(winStatus: WinningType) {
        switch winStatus {
        case .humanWin:
            self.currentHuman.currentScore += 1
        case .computerWin:
            self.currentBot.currentScore += 1
        default:
            print("Nothing")
        }
    }
    
//    func checkInMatchWin() -> WinningType {
//        if self.currentBot.currentScore > self.currentHuman.currentScore {
//            return .computerWin
//        }
//        else if self.currentBot.currentScore < self.currentHuman.currentScore {
//            return .humanWin
//        }
//        else {
//            return .draw
//        }
//    }
    func updateWinNumber() {
        // find final winner
        // update score of winner = current winner scores - current loser scores
        // if current winner scores - current loser scores = 0 -> no scores
        if self.currentBot.currentScore > self.currentHuman.currentScore {
            self.currentBot.totalScore += (self.currentBot.currentScore - self.currentHuman.currentScore)
            // update total score in array as well
            self.players[findPlayerId(for: self.currentBot.id)].totalScore = self.currentBot.totalScore
        }
        else if self.currentBot.currentScore < self.currentHuman.currentScore {
            self.currentHuman.totalScore += (self.currentHuman.currentScore - self.currentBot.currentScore)
            // update total score in array as well
            self.players[findPlayerId(for: self.currentHuman.id)].totalScore = self.currentHuman.totalScore
        }

        // reset current scores
        self.currentBot.currentScore = 0
        self.currentHuman.currentScore = 0
    }



}
