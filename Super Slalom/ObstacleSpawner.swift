//
//  ObstacleSpawner.swift
//  Super Slalom
//
//  Created by Bruno Thuma on 02/02/22.
//

import SpriteKit

class ObstacleSpawner {
    private var parent: SKNode
    
    var obstacles = [Obstacle]()
    
    private var currentTime: TimeInterval
    private var spawnInterval: TimeInterval = 0.3
    
    private var spawnOnLeft: Bool = true
    
    init (parent: SKNode) {
        self.parent = parent
        
        currentTime = spawnInterval
    }
    
    func update(deltaTime: TimeInterval, difficultyScale: CGFloat) {
        
        currentTime += deltaTime
        
        // Calculate interval
        if currentTime > spawnInterval / difficultyScale {
            spawn()
            currentTime -= spawnInterval
        }
        
        // Move all obstacles
        for obstacle in obstacles {
            obstacle.position.y += 100 * deltaTime * difficultyScale
        }
        
        if let firstObstacle = obstacles.first {
            
            let obstacleDespawnHeight = parent.frame.maxY + firstObstacle.frame.height / 2
            
            if firstObstacle.position.y > obstacleDespawnHeight {
                firstObstacle.removeFromParent()
                obstacles.removeFirst(1)
            }
        }
    }
    
    func spawn() {
        let randInt = Int.random(in: 1...100)
        let newObstacle: Obstacle
        if randInt > 10{
            newObstacle = Obstacle(obstacleType: .tree)
        } else{
            newObstacle = Obstacle(obstacleType: .tree)
        }
    
        let rangeRightLimit: CGFloat
        let rangeLeftLimit: CGFloat
        
        if spawnOnLeft {
            rangeLeftLimit = parent.frame.minX
            rangeRightLimit = -100 - newObstacle.frame.width / 2
        } else {
            rangeLeftLimit = 100 + (newObstacle.frame.width / 2)
            rangeRightLimit = parent.frame.maxX
        }
        
        newObstacle.position.x = CGFloat.random(in:  rangeLeftLimit ... rangeRightLimit)
        newObstacle.position.y = parent.frame.minY - newObstacle.size.height / 2
        
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
