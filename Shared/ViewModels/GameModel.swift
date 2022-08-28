//
//  GameModel.swift
//  PlayNow
//
//  Created by Nhung Tran on 17/08/2022.
// https://stackoverflow.com/questions/26845307/generate-random-alphanumeric-string-in-swift
// https://stackoverflow.com/questions/62602279/using-appstorage-for-string-map/62602643#62602643

import Foundation
import SwiftUI
import Combine

class GameModel: ObservableObject {
    // for iphone storage
    @Published var settings = SettingsManager.shared
    var cancellables = Set<AnyCancellable>()

    @Published var players = [Player]()

    @Published var currentBot: Player
    @Published var currentHuman: Player

    @Published var backToHome: Int?

    

    init() {
        
        self.currentBot = Player(username: "Bot", isHuman: false, currentScore: 0, totalScore: 0)
        self.currentHuman = Player(username: ModelUtility.randomUsername(), isHuman: true, currentScore: 0, totalScore: 0)
        
        // convert data to player to use
        convertDataToPlayer(from: self.settings.currentHuman, currentData: &(self.currentHuman))
        convertDataToPlayer(from: self.settings.currentBot, currentData: &(self.currentBot))
        
        players.append(contentsOf: [self.currentBot, self.currentHuman])
        convertDataToPlayers()
        
        // for app storage
        settings.objectWillChange
            .sink { [weak self] _ in
            self?.objectWillChange.send()
        }
            .store(in: &cancellables)
        
    }

    // MARK: - data <-> object conversion
    // MARK: convert a player only
    func convertPlayerToData(currentData: Player, storeData: inout Data) {
        guard let currentHumanData = try? JSONEncoder().encode(currentData) else { return }
        storeData = currentHumanData
    }
    func convertDataToPlayer(from: Data, currentData: inout Player) {
        guard let decodedCurrentHuman = try? JSONDecoder().decode(Player.self, from: from) else { return }
        currentData = decodedCurrentHuman
    }
    
    
    // MARK: convert player list
    func convertPlayersToData() {
        guard let currentHumanData = try? JSONEncoder().encode(self.players) else { return }
        self.settings.players = currentHumanData
    }
    func updateHumanData() {
        convertPlayerToData(currentData: self.currentHuman, storeData: &self.settings.currentHuman)
    }
    func updateBotData() {
        convertPlayerToData(currentData: self.currentBot, storeData: &self.settings.currentBot)
    }
    
    func convertDataToPlayers() {
        guard let decodedCurrentHuman = try? JSONDecoder().decode([Player].self, from: self.settings.players) else { return }
        self.players = decodedCurrentHuman
    }

    // MARK: - Update Player Info
    func findPlayerId(for id: UUID) -> Int {
        let currentPlayerIndex = players.firstIndex(where: {
            $0.id == id
        }) ?? 0
        return currentPlayerIndex
    }
    // MARK: sort players based on current score
    func sortPlayerInScore() {
        self.players = self.players.sorted(by: { $0.totalScore > $1.totalScore })
    }
    
    // MARK: update scores
    // update scores during match
    func updateScores(winStatus: WinningType) {
        switch winStatus {
        case .humanWin:
            self.currentHuman.currentScore += 1
            updateHumanData()
        case .computerWin:
            self.currentBot.currentScore += 1
            updateBotData()
        default:
            print("Nothing")
        }
    }
    
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
        
        // convert back to data to store change
        
        updateHumanData()
        updateBotData()
        convertPlayersToData()
    }
    
    // MARK: update username
    func updateUsername(newUsername: String) {
        self.currentHuman.username = newUsername
        self.players[findPlayerId(for: self.currentHuman.id)] = self.currentHuman
        updateHumanData()
        convertPlayersToData()
    }
    // MARK: switch user
    func switchUser(for userId: UUID) {
        let userIndex = findPlayerId(for: userId)
        self.currentHuman = self.players[userIndex]
        updateHumanData()
        
    }
    // MARK: add user
    func addUser(newUsername: String) {
        self.currentHuman = Player(username: newUsername, isHuman: true, currentScore: 0, totalScore: 0)
        updateHumanData()
        self.players.append(self.currentHuman)
        convertPlayersToData()
    }
    
    

    // MARK: - exit
    func exitGame() {
        
        // exit game and update total scores of players
        updateWinNumber()
        
        // sound
        SoundModel.startBackgroundMusic(bckName: "menu", type: "mp3")
        SoundModel.stopSoundEffect()
    }
    

}
