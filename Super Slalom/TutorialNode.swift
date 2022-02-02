//
//  TutorialNode.swift
//  Super Slalom
//
//  Created by Bruno Thuma on 01/02/22.
//

import SpriteKit

struct TutorialNode {
    let node: SKSpriteNode
    
    func setupAnimation () {
        var textures = [SKTexture]()
        
        textures.append(SKTexture(imageNamed: "intro1"))
        textures.append(SKTexture(imageNamed: "intro2"))
        
        let frames = SKAction.animate(with: textures,
                                      timePerFrame: 0.5,
                                      resize: false,
                                      restore: false)
                
        let repeatAnimation = SKAction.repeatForever(frames)
        node.run(repeatAnimation)
    }
}
