import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: Player!
    var slalomSpawner: SlalomSpawner!
    
    var points: Int = 0
    var pointsLabel: SKLabelNode!
    
    var livesLabel: SKLabelNode!
    
    var gameOverNode: SKSpriteNode!
    var introNode: SKSpriteNode!
    
    var lastUpdate = TimeInterval(0)
    
    var motionManager: CMMotionManager!
    var destX: CGFloat!
    
    var status: GameStatus = .intro
    
    // MARK: Overriden methods
    
    override func didMove(to view: SKView) {
        
        view.showsPhysics = false
        
        physicsWorld.contactDelegate = self
        
        // Setup player
        let playerNode = (self.childNode(withName: "Player") as! SKSpriteNode)
        player = Player(node: playerNode, parentNode: self)
        playerNode.removeFromParent()
        
        // Setup labels
        pointsLabel = (self.childNode(withName: "PointsLabel") as! SKLabelNode)
        livesLabel = (self.childNode(withName: "LivesLabel") as! SKLabelNode)
        
        introNode = childNode(withName: "Tutorial") as? SKSpriteNode
        
        // Setup game over and remove from screen for now
        gameOverNode = (self.childNode(withName: "GameOver") as! SKSpriteNode)
        gameOverNode.removeFromParent()
        
        setupSlalomSpawner()
        
        setupMotionManager()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        switch status {
        case .intro:
            start()
        case .playing:
            verifyTouches(touches: touches)
        case .gameOver:
            break
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Calculate time variance
        if lastUpdate == 0 {
            lastUpdate = currentTime
            return
        }
        
        let deltaTime = currentTime - lastUpdate
        lastUpdate = currentTime
        
        switch status {
        case .intro:
            break
        case .playing:
            playingStatusUpdate(deltaTime: deltaTime)
        case .gameOver:
            break
        }
        
    }
    
    // MARK: Intro status methods
    
    func start() {
        status = .playing
        addChild(player.node)
        introNode.removeFromParent()
    }
    
    // MARK: Playing status methods
    
    func verifyTouches(touches: Set<UITouch>) {
        
        for touch in touches {
            
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            switch touchedNode.name {
            case "RedSlalomButton":
                player.changeStickColor(color: .red)
            case "BlueSlalomButton":
                player.changeStickColor(color: .blue)
            default:
                break
            }
        }
    }
    
    
    func playingStatusUpdate(deltaTime: TimeInterval) {
        // Update time on slalomSpawner
        slalomSpawner.update(deltaTime: deltaTime)
        
        player.move(destX)
    }
    
    // MARK: Game Over methods
    
    func gameOver() {
        status = .gameOver
        addChild(gameOverNode)
    }
    
    func reset() {
        status = .intro
        addChild(introNode)
        player.reset()
        slalomSpawner.reset()
    }
    
    // MARK: Setup methods
    
    func setupMotionManager() {
        self.motionManager = CMMotionManager()
        self.destX = 0.0
        
        if motionManager.isAccelerometerAvailable {
            
            motionManager.accelerometerUpdateInterval = 0.01
            motionManager.startAccelerometerUpdates(to: .main) { (data, error) in
                
                guard let data = data, error == nil else {
                    return
                }
                
                let currentX = self.player.node.position.x
                self.destX = currentX + CGFloat(data.acceleration.x * 20)
            }
        }
    }
    
    func setupSlalomSpawner() {
        let redSlalomNode = (self.childNode(withName: "RedSlalom") as! SKSpriteNode)
        let blueSlalomNode = (self.childNode(withName: "BlueSlalom")  as! SKSpriteNode)
        slalomSpawner = SlalomSpawner(redSlalomModel: redSlalomNode,
                                      blueSlalomModel: blueSlalomNode,
                                      parent: self)
    }
    
    // MARK: Nodes contact methods
    
    func didBegin(_ contact: SKPhysicsContact) {
        // Filters possible contacts envolving the player
        // Player is either bodyA or bodyB
        if contact.bodyA.node?.name == "Player" {
            playerContact(with: contact.bodyB.node!)
        }
        else if contact.bodyB.node?.name == "Player" {
            playerContact(with: contact.bodyA.node!)
        }
    }
    
    func playerContact(with node: SKNode) {
        // Gets node usarData for slalom verification
        let isRedSlalom = node.userData?.value(forKey: "isRed") as! Bool
        
        let slalomType: SlalomType = isRedSlalom ? .red : .blue
        
        if slalomType == player.stickColor {
            points += 1
            pointsLabel.text = "\(points) 🏴"
        } else {
            player.lives -= 1
            
            if player.lives <= 0 {
                gameOver()
            } else {
                livesLabel.text = "\(player.lives)❤️"
            }
            
        }
    }
}

enum GameStatus {
    case intro
    case playing
    case gameOver
}
