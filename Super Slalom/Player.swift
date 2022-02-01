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
        self.lives = 5
        self.startPosition = node.position
        self.parent = parentNode
    }
    
    func move(_ destX: CGFloat) {
        if destX < parent.frame.maxX && destX > parent.frame.minX {
            node.position.x = destX
        }
    }
    
    func changeStickColor(color: SlalomType) {
        switch color {
        case .blue:
            stickColor = .blue
        case .red:
            stickColor = .red
        }
    }
    
    func reset() {
        lives = 5
    }
}
