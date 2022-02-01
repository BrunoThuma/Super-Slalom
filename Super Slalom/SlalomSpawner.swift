//
//  SlalomSpawner.swift
//  Super Slalom
//
//  Created by Bruno Thuma on 28/01/22.
//

import Foundation
import SpriteKit

class SlalomSpawner {
    private var redSlalomModel: SKNode
    private var blueSlalomModel: SKNode
    private var parent: SKNode
    private var slaloms = [Slalom]()
    
    private var isBlueSlalom = true
    
    private var currentTime: TimeInterval = 0
    
    private let spawnInterval: TimeInterval = 3
    
    init(redSlalomModel: SKNode, blueSlalomModel: SKNode, parent: SKNode) {
        self.redSlalomModel = redSlalomModel
        self.blueSlalomModel = blueSlalomModel
        self.parent = parent
        currentTime = spawnInterval
    }
    
    func update(deltaTime: TimeInterval) {
        
        currentTime += deltaTime
        
        // Calculate interval
        if currentTime > spawnInterval {
            spawn()
            currentTime -= spawnInterval
        }
        
        // Move all slaloms
        for slalom in slaloms {
            slalom.node.position.y += 50 * deltaTime
        }
        
        if let firstSlalom = slaloms.first {
            if firstSlalom.node.position.y >= parent.frame.maxY {
                firstSlalom.node.removeFromParent()
                slaloms.removeFirst(1)
            }
        }
    }
    
//    func didPlayerSuccessfullyScore(_ playerPosition: CGPoint) -> Bool {
//        
//        let slalomMaxY: CGFloat = slaloms.first!.node.position.y + 25
//        let slalomMinY: CGFloat = slaloms.first!.node.position.y - 25
//
//        if slaloms.first!.node.position.y > (playerPosition.y + 50) {
//            return slaloms.first!.wasHit
//        }
//
//
//    }
    
    func spawn() {
        let newSlalom: SKNode!
        if isBlueSlalom {
            newSlalom = (blueSlalomModel.copy() as! SKNode)
            slaloms.append(Slalom(node: newSlalom as! SKSpriteNode, color: .blue))
            isBlueSlalom = false
        }
        else {
                newSlalom = (redSlalomModel.copy() as! SKNode)
                slaloms.append(Slalom(node: newSlalom as! SKSpriteNode, color: .red))
                isBlueSlalom = true
        }
        newSlalom.position.x = CGFloat.random(in: -100...100)
        parent.addChild(newSlalom)
        
    }
    
    func reset() {
        for slalom in slaloms {
            slalom.node.removeFromParent()
        }
        
        slaloms.removeAll()
        currentTime = spawnInterval
    }
}
