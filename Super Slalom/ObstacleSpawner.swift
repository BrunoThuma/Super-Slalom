//
//  ObstacleSpawner.swift
//  Super Slalom
//
//  Created by Bruno Thuma on 02/02/22.
//

import SpriteKit

class ObstacleSpawner {
    private var parent: SKNode
    private var obstacleModel: SKNode
    
    var obstacles = [SKSpriteNode]()
    
    private var currentTime: TimeInterval
    private var spawnInterval: TimeInterval = 0.3
    
    private var spawnOnLeft: Bool = true
    
    init (obstacleModel: SKNode, parent: SKNode) {
        self.obstacleModel = obstacleModel as! SKSpriteNode
        self.parent = parent
        
        currentTime = spawnInterval
    }
    
    func update(deltaTime: TimeInterval, difficultyScale: CGFloat) {
        
        currentTime += deltaTime
        
        // Calculate interval
        if currentTime > spawnInterval {
            spawn()
            currentTime -= spawnInterval
        }
        
        // Move all obstacles
        for obstacle in obstacles {
            obstacle.position.y += 100 * deltaTime * difficultyScale
        }
        
        if let firstObstacle = obstacles.first {
            
            let obstacleDespawnHeight = parent.frame.maxY + obstacleModel.frame.height / 2
            
            if firstObstacle.position.y > obstacleDespawnHeight {
                firstObstacle.removeFromParent()
                obstacles.removeFirst(1)
            }
        }
    }
    
    func spawn() {
        let newObstacle = obstacleModel.copy() as! SKSpriteNode
        let rangeRightLimit: CGFloat
        let rangeLeftLimit: CGFloat
        
        if spawnOnLeft {
            rangeLeftLimit = parent.frame.minX
            rangeRightLimit = -100 - obstacleModel.frame.width / 2
        } else {
            rangeLeftLimit = 100 + (obstacleModel.frame.width / 2)
            rangeRightLimit = parent.frame.maxX
        }
        
        newObstacle.position.x = CGFloat.random(in:  rangeLeftLimit ... rangeRightLimit)
        
        parent.addChild(newObstacle)
        obstacles.append(newObstacle)
        
        spawnOnLeft = !spawnOnLeft
    }
    
    func reset() {
        for obstacle in obstacles {
            obstacle.removeFromParent()
        }
        
        obstacles.removeAll()
        currentTime = spawnInterval
    }
}
