//
//  Slalom.swift
//  Super Slalom
//
//  Created by Bruno Thuma on 28/01/22.
//

import SpriteKit


class Slalom: SKSpriteNode {
    var slalomType: SlalomType
    var wasHit: Bool
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        self.slalomType = .blue
        self.wasHit = false
        
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init(slalomType: SlalomType, wasHit: Bool = false) {
        
        let imageName: String = slalomType.left
        
        let slalomTexture = SKTexture(imageNamed: imageName)
        
        self.init(texture: slalomTexture, color: .blue, size: slalomTexture.size())
        
        self.slalomType = slalomType
        self.wasHit = wasHit
        
        self.size = CGSize(width: 107, height: 85)
        
        self.zPosition = 0
        
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width / 2,
                                                             height: self.size.height / 3),
                                         center: CGPoint(x: 0, y: self.frame.maxY))

        self.physicsBody?.isDynamic = false

        // Category 1
        self.physicsBody?.categoryBitMask = 0x1
        // Collisions with no one
        self.physicsBody?.collisionBitMask = 0
        // Contacts with everybody
        self.physicsBody?.contactTestBitMask = UInt32.max
        
        self.yScale = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupAnimation () {
        var textures = [SKTexture]()
        
        // slalomType = .red
        textures.append(SKTexture(imageNamed: slalomType.left)) // -> "pinkflag_left"
        textures.append(SKTexture(imageNamed: slalomType.right)) // -> "pinkflag_right"
        
        let frames = SKAction.animate(with: textures,
                                      timePerFrame: 0.8,
                                      resize: false,
                                      restore: false)
                
        let repeatAnimation = SKAction.repeatForever(frames)
        run(repeatAnimation)
    }
    
    func setupWasHitAnimation() {
        var textures = [SKTexture]()
        
        textures.append(SKTexture(imageNamed: slalomType.fallenFlag1))
        textures.append(SKTexture(imageNamed: slalomType.fallenFlag2))
        textures.append(SKTexture(imageNamed: slalomType.fallenFlag3))
        textures.append(SKTexture(imageNamed: slalomType.fallenFlag4))
        textures.append(SKTexture(imageNamed: slalomType.fallenFlag5))
        textures.append(SKTexture(imageNamed: slalomType.fallenFlag6))
        textures.append(SKTexture(imageNamed: slalomType.fallenFlag7))
        textures.append(SKTexture(imageNamed: slalomType.fallenFlag8))
        
        let frames = SKAction.animate(with: textures,
                                      timePerFrame: 0.07,
                                      resize: true,
                                      restore: false)
        
       // TENTATIVA animar com o mesmo top
        // let moveAnimation = SKAction.move(
        
        self.removeAllActions()
        self.yScale = 1
        run(frames)
        
        
    }
    
}
