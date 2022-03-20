//
//  AudioManager.swift
//  Super Slalom
//
//  Created by Bruno Thuma on 11/03/22.
//

import SpriteKit
import AVFAudio

final class SuperSlalomAudioPlayer: SKAudioNode {
    
    private var isSoundsMuted: Bool = false
    private var isMusicMuted: Bool = false
    
    private var skiingSound = SKAction.playSoundFileNamed("skiing.mp3", waitForCompletion: false)
    private var hitTreeSound = SKAction.playSoundFileNamed("hit_tree.mp3", waitForCompletion: false)
    private var hitRightFlagSound = SKAction.playSoundFileNamed("hit_right_flag.mp3", waitForCompletion: false)
    private var hitWrongFlagSound = SKAction.playSoundFileNamed("hit_wrong_flag.mp3", waitForCompletion: false)
    private var lifeCollectSound = SKAction.playSoundFileNamed("life_collect.mp3", waitForCompletion: false)
    
    public static let shared = SuperSlalomAudioPlayer(fileNamed: "background_song.mp3")
    
    public func muteSounds() {
        self.isSoundsMuted = true
    }
    
    public func unmuteSounds() {
        self.isSoundsMuted = false
    }
    
    public func muteMusic() {
        self.run(SKAction.stop())
    }
    
    public func unmuteMusic() {
        self.isMusicMuted = false
    }
    
    public func runSkiingSound() {
        if !isSoundsMuted {
            self.run(skiingSound)
        }
    }
    
    public func runHitTreeSound() {
        if !isSoundsMuted {
            self.run(hitTreeSound)
        }
    }
    
    public func runRightFlagSound() {
        if !isSoundsMuted {
            self.run(hitRightFlagSound)
        }
    }
    
    public func runWrongFlagSound() {
        if !isSoundsMuted {
            self.run(hitWrongFlagSound)
        }
    }
    
    public func runLifeCollectSound() {
        if !isSoundsMuted {
            self.run(lifeCollectSound)
        }
    }
}
