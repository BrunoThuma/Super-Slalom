import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var totalLifes: Int = 3
    
    var player: Player!
    var slalomSpawner: SlalomSpawner!
    
    var points: Int = 0
    var pointsLabel: SKLabelNode!
    
    var livesLabel: SKLabelNode!
    
    var lastUpdate = TimeInterval(0)
    
    var motionManager: CMMotionManager!
    var destX: CGFloat!
    
    // MARK: Overriden methods
    
    override func didMove(to view: SKView) {
        
        view.showsPhysics = true
        
        physicsWorld.contactDelegate = self
        
        // Setup player
        let playerNode = (self.childNode(withName: "Player") as! SKSpriteNode)
        player = Player(node: playerNode)
        
        // Setup labels
        pointsLabel = (self.childNode(withName: "PointsLabel") as! SKLabelNode)
        livesLabel = (self.childNode(withName: "LivesLabel") as! SKLabelNode)
        
        setupSlalomSpawner()
        
        setupMotionManager()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
    
    override func update(_ currentTime: TimeInterval) {
        
        // Calculate time variance
        if lastUpdate == 0 {
            lastUpdate = currentTime
            return
        }
        
        let deltaTime = currentTime - lastUpdate
        lastUpdate = currentTime
        
        // Update time on slalomSpawner
        slalomSpawner.update(deltaTime: deltaTime)
        
        player.move(destX)
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
                self.destX = currentX + CGFloat(data.acceleration.x * 15)
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
            pointsLabel.text = "Points: \(points)"
        } else {
            player.lives -= 1
            
            // FIXME: Remove max verification and do proper game over
            livesLabel.text = String(repeating: "❤️ ", count: max(player.lives, 1))
        }
    }
}
