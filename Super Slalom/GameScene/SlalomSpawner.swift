import SpriteKit

class SlalomSpawner {
    private var parent: GameScene
    private var slaloms = [Slalom]()
    
    private var isBlueSlalom = true
    
    private var currentTime: TimeInterval = 0
    
    private let spawnInterval: TimeInterval = 1.5
    
    init(parent: SKNode) {
        // TODO: Maybe this should be a weak reference
        self.parent = parent as! GameScene
        
        currentTime = spawnInterval
    }
    
    func update(deltaTime: TimeInterval, difficultyScale: CGFloat) {
        
        currentTime += deltaTime
        
        // Calculate interval
        if currentTime > spawnInterval / (difficultyScale - 1.5) {
            spawn()
            currentTime = 0
        }
        
        
        // Move all slaloms
        for slalom in slaloms {
            slalom.position.y += 100 * deltaTime + difficultyScale
            
        }
        
        // Eliminate first slalom in case it reaches the end of frame
        if let firstSlalom = slaloms.first {
            if firstSlalom.position.y >= parent.frame.maxY {
                if !firstSlalom.wasHit {
                    parent.discountPlayerLife()
                }
                firstSlalom.removeFromParent()
                slaloms.removeFirst(1)
            }
        }
    }
    
    func spawn() {
        let newSlalom: Slalom!
        isBlueSlalom = Bool.random()
        if isBlueSlalom {
            newSlalom = Slalom(slalomType: .blue)
            slaloms.append(newSlalom)
        } else {
            newSlalom = Slalom(slalomType: .red)
            slaloms.append(newSlalom)
            
        }
        newSlalom.position.x = CGFloat.random(in: -100...100)
        newSlalom.position.y = parent.frame.minY - (newSlalom.size.height/2)
        parent.addChild(newSlalom)
        
        newSlalom.setupAnimation()
        
    }
    
    func reset() {
        for slalom in slaloms {
            slalom.removeFromParent()
        }
        
        slaloms.removeAll()
        currentTime = spawnInterval
    }
    
    func gameOver() {
        for slalom in slaloms {
            slalom.removeAllActions()
        }
    }
}
