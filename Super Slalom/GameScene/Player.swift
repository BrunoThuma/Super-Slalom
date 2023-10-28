//
//  Player.swift
//  Super Slalom
//
//  Created by Bruno Thuma on 28/01/22.
//

import Foundation
import SpriteKit

class Player {
    
    let parent: SKNode
    
    let startPosition: CGPoint
    
    let node: SKSpriteNode!
    
    var stickColor: SlalomType!
    
    var lives: Int
    
    init(node: SKSpriteNode, parentNode: SKNode) {
        self.node = node
        self.lives = 1
        self.startPosition = node.position
        self.parent = parentNode
        
        node.size = CGSize(width: node.size.width + 5,
                           height: node.size.height + 5)
    }
    
    func move(_ destX: CGFloat) {
        if destX < 180 && destX > -180 {
            node.position.x = destX
        }
    }
    
    // Called when player presses buttons
    func changeStickColor(color: SlalomType) {
        
        stickColor = color
        
        switch color {
        case .blue:
            node.texture = SKTexture(imageNamed: "player_blue")
        case .red:
            node.texture = SKTexture(imageNamed: "player_pink")
        }
    }
    
    func reset() {
        lives = 5
    }
}
