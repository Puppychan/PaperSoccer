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
import SwiftUI
import Combine

class GameModel: ObservableObject {
    // for iphone storage
    @Published var settings = SettingsManager.shared
    var cancellables = Set<AnyCancellable>()

    // list of player
    @Published var players = [Player]()

    // current players
    @Published var currentBot: Player
    @Published var currentHuman: Player

    // list of badges
    let badges = [
        "Play a Game",
        "Play 10 Games",
        "Read Instruction",
        "Win for the first time",
        "Win 10 times",
        "Win 100 times",
        "Score 10 points",
        "Score 100 points"
    ]

    init() {
        // init current players
        self.currentBot = Player(username: "Bot", isHuman: false, currentScore: 0, totalScore: 0, numGamePlay: 0, numWin: 0, isReadInstruction: false, badges: [])
        self.currentHuman = Player(username: ModelUtility.randomUsername(), isHuman: true, currentScore: 0, totalScore: 0, numGamePlay: 0, numWin: 0, isReadInstruction: false, badges: [])
        
        // convert data to player to use
        convertDataToPlayer(from: self.settings.currentHuman, currentData: &(self.currentHuman))
        convertDataToPlayer(from: self.settings.currentBot, currentData: &(self.currentBot))
        
        // list players
        players.append(contentsOf: [self.currentBot, self.currentHuman])
        convertDataToPlayers()
        
        // for app storage
        settings.objectWillChange
            .sink { [weak self] _ in
            self?.objectWillChange.send()
        }
            .store(in: &cancellables)
        
    }
    
    // MARK: -  badges
    func addBadges() {
        for i in 0..<badges.count {
            switch badges[i] {
            case "Play a Game":
                if self.currentHuman.numGamePlay >= 1 {
                    self.currentHuman.badges.insert(i)
                }
            case "Play 10 Games":
                if self.currentHuman.numGamePlay >= 10 {
                    self.currentHuman.badges.insert(i)
                }
            case "Read Instruction":
                if self.currentHuman.isReadInstruction {
                    self.currentHuman.badges.insert(i)
                }
                
            case "Win for the first time":
                if self.currentHuman.numWin >= 1 {
                    self.currentHuman.badges.insert(i)
                }
            case "Win 10 times":
                if self.currentHuman.numWin >= 10 {
                    self.currentHuman.badges.insert(i)
                }
            case "Win 100 times":
                if self.currentHuman.numWin >= 100 {
                    self.currentHuman.badges.insert(i)
                }
            case "Score 10 points":
                if self.currentHuman.totalScore >= 10 {
                    self.currentHuman.badges.insert(i)
                }
            case "Score 100 points":
                if self.currentHuman.totalScore >= 100 {
                    self.currentHuman.badges.insert(i)
                }
            default:
                print("Nothing Badges")
            }
            
        }
    }
    
    // MARK: check if the current player has badge that has index
    func isHaveBadge(for index: Int) -> Bool {
        return self.currentHuman.badges.contains(index) 
        
    }
    

    // MARK: - data <-> object conversion
    // MARK: convert a player only
    // player -> data -> appstorage
    func convertPlayerToData(currentData: Player, storeData: inout Data) {
        guard let currentHumanData = try? JSONEncoder().encode(currentData) else { return }
        storeData = currentHumanData
    }
    // appstorage -> data -> player
    func convertDataToPlayer(from: Data, currentData: inout Player) {
        guard let decodedCurrentHuman = try? JSONDecoder().decode(Player.self, from: from) else { return }
        currentData = decodedCurrentHuman
    }
    
    
    // MARK: convert player list
    // list players -> data -> appstorage
    func convertPlayersToData() {
        guard let currentHumanData = try? JSONEncoder().encode(self.players) else { return }
        self.settings.players = currentHumanData
    }
    // appstorage -> data -> list players
    func convertDataToPlayers() {
        guard let decodedCurrentHuman = try? JSONDecoder().decode([Player].self, from: self.settings.players) else { return }
        self.players = decodedCurrentHuman
    }
    
    // MARK: short update
    // update human -> data
    func updateHumanData() {
        convertPlayerToData(currentData: self.currentHuman, storeData: &self.settings.currentHuman)
    }
    // update bot -> data
    func updateBotData() {
        convertPlayerToData(currentData: self.currentBot, storeData: &self.settings.currentBot)
    }
    


    // MARK: - Update Player Info
    // MARK: find current player id in player list using id
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
    // update 1 player score
    func updatePlayerScores(player: inout Player) {
        player.currentScore += 1
        player.numGamePlay += 1
        player.numWin += 1
    }
    // update scores during match
    func updateScores(winStatus: WinningType) {
        switch winStatus {
        case .humanWin:
            updatePlayerScores(player: &self.currentHuman)
            updateHumanData()
        case .computerWin:
            updatePlayerScores(player: &self.currentBot)
            updateBotData()
        default:
            print("Nothing")
        }
    }
    
    // MARK: update general win number
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
        self.currentHuman = Player(username: newUsername, isHuman: true, currentScore: 0, totalScore: 0, numGamePlay: 0, numWin: 0, isReadInstruction: false, badges: [])
        updateHumanData()
        self.players.append(self.currentHuman)
        convertPlayersToData()
    }
    
    // MARK: update read instruction
    func updateReadInstruction() {
        self.currentHuman.isReadInstruction = true
        updateHumanData()
    }
    


    // MARK: - exit
    func exitGame() {
        
        // exit game and update total scores of players
        updateWinNumber()
        print(self.currentHuman.username, self.currentHuman.totalScore)
        // sound
        SoundModel.startBackgroundMusic(bckName: "menu", type: "mp3")
        SoundModel.stopSoundEffect()
    }
    

}
