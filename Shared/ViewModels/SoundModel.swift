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
 // https://www.zerotoappstore.com/how-to-add-background-music-in-swift.html
 */


import Foundation
import AVFoundation


struct SoundModel {
    
    static var audioPlayer: AVAudioPlayer?
    static var audioPlayer1: AVAudioPlayer?


    // MARK: - start sound
    // MARK: play sound effect (1 time play only)
    static func playSound(sound soundPath: String, type: String) {
        if let path = Bundle.main.path(forResource: soundPath, ofType: type) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer?.play()
            } catch {
                print("ERROR: Could not find and play sound file")
            }
        }
    }

    // MARK: play background music (infinite loop)
    static func startBackgroundMusic(bckName: String, type: String) {
        if let bundle = Bundle.main.path(forResource: "bck-\(bckName)", ofType: type) {
            let backgroundMusic = NSURL(fileURLWithPath: bundle)
            do {
                audioPlayer1 = try AVAudioPlayer(contentsOf: backgroundMusic as URL)
                guard let audioPlayer = audioPlayer1 else { return }
                audioPlayer.numberOfLoops = -1
                audioPlayer.prepareToPlay()
                audioPlayer.play()
//                try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
//                try? AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print("ERROR: Could not find and play background music")
            }
        }
    }
    // MARK: - stop sound
    // MARK: stop background music
    static func stopBackgroundMusic() {
        guard let audioPlayer = audioPlayer1 else { return }
        audioPlayer.stop()
    }
    
    // MARK: stop sound effect
    static func stopSoundEffect() {
        guard let audioPlayer = audioPlayer else { return }
        audioPlayer.stop()
    }
}
