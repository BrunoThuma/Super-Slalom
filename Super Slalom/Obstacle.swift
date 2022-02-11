//
//  Obstacle.swift
//  Super Slalom
//
//  Created by Giovana Garcia on 08/02/22.
//

import SpriteKit

class Obstacle: SKSpriteNode {
    var obstacleType: ObstacleType
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        self.obstacleType = .tree1
        
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init(obstacleType: ObstacleType) {
        
        let imageName: String = obstacleType.rawValue
        
        let obstacleTexture = SKTexture(imageNamed: imageName)
        
        self.init(texture: obstacleTexture, color: .blue, size: obstacleTexture.size())
        
        self.name = "Obstacle"
        
        self.obstacleType = obstacleType
        
        self.size = CGSize(width: 89.5, height: 90.5)
        
        self.zPosition = 2
        
        // TODO: implement different bodies for each case
        switch obstacleType {
        case .tree1:
            self.physicsBody = SKPhysicsBody(circleOfRadius: 44.7)
        case .tree2:
            self.physicsBody = SKPhysicsBody(circleOfRadius: 44.7)
        case .tree3:
            self.physicsBody = SKPhysicsBody(circleOfRadius: 44.7)
        case .littleHouse:
            self.physicsBody = SKPhysicsBody(rectangleOf: self.frame.size)
        case .bigHouse:
            self.physicsBody = SKPhysicsBody(rectangleOf: self.frame.size)
        }
        

        self.physicsBody?.isDynamic = false

        // Category 1
        self.physicsBody?.categoryBitMask = 0x1
        // Collisions with no one
        self.physicsBody?.collisionBitMask = 0
        // Contacts with everybody
        self.physicsBody?.contactTestBitMask = UInt32.max
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
