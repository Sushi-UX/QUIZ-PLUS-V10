//
//  SoundManager.swift
//  QUIZ-PLUS-V09
//
//  Created by Raymond Choy on 7/18/19.
//  Copyright © 2019 thechoygroup. All rights reserved.
//

import AVFoundation
import AudioToolbox

struct SoundManager {
    
    var gameSound: SystemSoundID = 0
    var soundURL = URL(fileURLWithPath: Bundle.main.path(forResource: "", ofType: "wav")!)
    let audioPlayer = AVAudioPlayer()
    
    
    mutating func playGoodAnswerSound() {
        self.soundURL = URL(fileURLWithPath: Bundle.main.path(forResource: "GameSound", ofType: "wav")!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &gameSound)
        AudioServicesPlaySystemSound(gameSound)
    }
    
    mutating func playBadAnswerSound() {
        self.soundURL = URL(fileURLWithPath: Bundle.main.path(forResource: "NoSound", ofType: "wav")!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &gameSound)
        AudioServicesPlaySystemSound(gameSound)
    }
}

