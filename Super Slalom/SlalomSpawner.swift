//
//  SlalomSpawner.swift
//  Super Slalom
//
//  Created by Bruno Thuma on 28/01/22.
//

import Foundation
import SpriteKit

class SlalomSpawner {
    private var redSlalomModel: SKSpriteNode
    private var blueSlalomModel: SKSpriteNode
    private var parent: SKNode
    private var slaloms = [Slalom]()
    
    private var isBlueSlalom = true
    
    private var currentTime: TimeInterval = 0
    
    private let spawnInterval: TimeInterval = 3
    
    init(redSlalomModel: SKSpriteNode, blueSlalomModel: SKSpriteNode, parent: SKNode) {
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
            slalom.node.position.y += 100 * deltaTime
        }
        
        // Eliminate first slalom in case it reaches the end of frame
        if let firstSlalom = slaloms.first {
            if firstSlalom.node.position.y >= parent.frame.maxY {
                firstSlalom.node.removeFromParent()
                slaloms.removeFirst(1)
            }
        }
    }
    
    func spawn() {
        let newSlalomNode: SKSpriteNode!
        let newSlalom: Slalom!
        
        if isBlueSlalom {
            newSlalomNode = (blueSlalomModel.copy() as! SKSpriteNode)
            newSlalom = Slalom(node: newSlalomNode, color: .blue)
            slaloms.append(newSlalom)
            isBlueSlalom = false
        } else {
            newSlalomNode = (redSlalomModel.copy() as! SKSpriteNode)
            newSlalom = Slalom(node: newSlalomNode, color: .red)
            slaloms.append(newSlalom)
            
            isBlueSlalom = true
        }
        newSlalomNode.position.x = CGFloat.random(in: -100...100)
        parent.addChild(newSlalomNode)
        
    }
    
    func reset() {
        for slalom in slaloms {
            slalom.node.removeFromParent()
        }
        
        slaloms.removeAll()
        currentTime = spawnInterval
    }
}
