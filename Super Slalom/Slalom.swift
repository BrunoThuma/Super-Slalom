//
//  Slalom.swift
//  Super Slalom
//
//  Created by Bruno Thuma on 28/01/22.
//

import SpriteKit

struct Slalom {
    let node: SKSpriteNode
    let color: SlalomType
    var wasHit: Bool = false
    
    func setupAnimation () {
        var textures = [SKTexture]()
        
        textures.append(SKTexture(imageNamed: "intro-1"))
        textures.append(SKTexture(imageNamed: "intro-2"))
        
        let frames = SKAction.animate(with: textures,
                                      timePerFrame: 0.5,
                                      resize: false,
                                      restore: false)
                
        let repeatAnimation = SKAction.repeatForever(frames)
        node.run(repeatAnimation)
    }
}
