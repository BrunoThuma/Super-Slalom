//
//  Player.swift
//  Super Slalom
//
//  Created by Bruno Thuma on 28/01/22.
//

import Foundation
import SpriteKit

class Player {
    
    let node: SKSpriteNode!
    
    var stickColor: SlalomType!
    
    var lives: Int
    
    init(node: SKSpriteNode) {
        self.node = node
        self.lives = 3
    }
    
    func move(direction: UISwipeGestureRecognizer.Direction) {
        switch direction {
        case .right:
            node.run(SKAction.move(by: CGVector(dx: 35, dy: 0), duration: 0.2))
            
        case .left:
            node.run(SKAction.move(by: CGVector(dx: -35, dy: 0), duration: 0.2))
            
        default:
            break
        }
    }
    
    func move(_ destX: CGFloat) {
        node.position.x = destX
    }
    
    func changeStickColor(color: SlalomType) {
        switch color {
        case .blue:
            stickColor = .blue
        case .red:
            stickColor = .red
        }
    }
}
