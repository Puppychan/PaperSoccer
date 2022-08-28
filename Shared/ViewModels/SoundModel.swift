//
//  SoundModel.swift
//  PaperSoccer (iOS)
//
//  Created by Nhung Tran on 28/08/2022.
// https://www.zerotoappstore.com/how-to-add-background-music-in-swift.html

import Foundation
import AVFoundation


struct SoundModel {
//    static let shared = MusicPlayer()
    static var audioPlayer: AVAudioPlayer?
    static var audioPlayer1: AVAudioPlayer?


    // MARK: - sound
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
    static func stopBackgroundMusic() {
        guard let audioPlayer = audioPlayer1 else { return }
        audioPlayer.stop()
    }
    static func stopSoundEffect() {
        guard let audioPlayer = audioPlayer else { return }
        audioPlayer.stop()
    }
}
