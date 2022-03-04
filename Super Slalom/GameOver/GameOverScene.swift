//
//  GameOverScene.swift
//  Super Slalom
//
//  Created by Bruno Thuma on 03/03/22.
//

import SpriteKit

class GameOverScene: SKScene {
    let totalFlags, finalDistance: Int
    let didUseAdRevive: Bool

    init(totalFlags: Int, finalDistance: Int, didUseAdRevive: Bool) {
        self.totalFlags = totalFlags
        self.finalDistance = finalDistance
        self.didUseAdRevive = didUseAdRevive
        
        super.init()
        
        self.size = CGSize(width: 650, height: 844)
        self.scaleMode = .aspectFill
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
