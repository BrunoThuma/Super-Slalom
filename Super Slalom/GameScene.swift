import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    static var sharedInstance: GameScene = GameScene()
    
    var status: GameStatus = .intro
    
    private var player: Player!
    private var slalomSpawner: SlalomSpawner!
    private var obstacleSpawner: ObstacleSpawner!
    
    private var points: Int = 0
    private var distance: Float = 0.0
    
    private var hub: SKSpriteNode!
    private var pointsLabel: SKLabelNode!
    private var livesLabel: SKLabelNode!
    private var distanceLabel: SKLabelNode!
    private var pausedLabel: SKLabelNode!
    
    private var gameOverNode: SKNode!
    private var tutorialOverlay: TutorialNode!
    
    private var lastUpdate = TimeInterval(0)
    
    private var motionManager: CMMotionManager!
    private var destX: CGFloat!
    
    var difficultyScale: CGFloat = 2.0 // bandeira.wasHit -> difficulty += 0.01
    
    // MARK: Overriden methods
    
    override func didMove(to view: SKView) {
        
        view.showsPhysics = true
        
        physicsWorld.contactDelegate = self
        
        GameScene.sharedInstance = self
        
        // Setup player
        let playerNode = (self.childNode(withName: "Player") as! SKSpriteNode)
        player = Player(node: playerNode, parentNode: self)
        playerNode.removeFromParent()
        
        // Setup tree on the side of playable area
        obstacleSpawner = ObstacleSpawner(parent: self)
        
        // Setup labels
        hub = (self.childNode(withName: "HUB") as! SKSpriteNode)
        pointsLabel = (hub.childNode(withName: "PointsLabel") as! SKLabelNode)
        livesLabel = (hub.childNode(withName: "LivesLabel") as! SKLabelNode)
        distanceLabel = (hub.childNode(withName: "DistanceLabel") as! SKLabelNode)
        
        let introNode = (childNode(withName: "Tutorial") as! SKSpriteNode)
        tutorialOverlay = TutorialNode(node: introNode)
        
        // Setup game over and remove from screen for now
        gameOverNode = self.childNode(withName: "GameOver")
        gameOverNode.removeFromParent()
        
        pausedLabel = (childNode(withName: "PausedLabel") as! SKLabelNode)
        pausedLabel.removeFromParent()
        
        // Setup tutorial overlay animation
        tutorialOverlay.setupAnimation()
        
        // Setup slalom spawner
        slalomSpawner = SlalomSpawner(parent: self)
        
        setupMotionManager()
    }
    
    // Changing to custom font
    
    func loadFonts() {
        livesLabel.fontName = "Rubik-Black"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        switch status {
        case .intro:
            start()
        case .playing:
            verifyTouches(touches: touches)
        case .paused:
            unpauseGame()
        case .gameOver:
            reset()
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
            playingStatusUpdate(currentTime: currentTime, deltaTime: deltaTime)
        case .paused:
            break
        case .gameOver:
            break
        }
        
    }
    
    // MARK: Intro status methods
    
    func start() {
        status = .playing
        addChild(player.node)
        tutorialOverlay.node.removeFromParent()
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
    
    
    func playingStatusUpdate(currentTime: TimeInterval, deltaTime: TimeInterval) {
        // Update time on slalomSpawner and obstacleSpawner
        slalomSpawner.update(deltaTime: deltaTime, difficultyScale: difficultyScale)
        obstacleSpawner.update(deltaTime: deltaTime, difficultyScale: difficultyScale)
        
        player.move(destX)
        
        distance += Float(deltaTime) * 2
        
        distanceLabel.text = "\(Int(distance.rounded()))m"
    }
    
    // MARK: Pause methods
    
    func pauseGame() {
        status = .paused
        addChild(pausedLabel)
    }
    
    func unpauseGame() {
        status = .playing
        pausedLabel.removeFromParent()
    }
    
    // MARK: Game Over methods
    
    func gameOver() {
        status = .gameOver
        slalomSpawner.gameOver()
        addChild(gameOverNode)
        
        let gameOverPoints = (gameOverNode.childNode(withName: "GameOverPointsLabel") as! SKLabelNode)
        let gameOverDistance = (gameOverNode.childNode(withName: "GameOverDistanceLabel") as! SKLabelNode)
        
        gameOverPoints.text = "\(points)"
        gameOverDistance.text = "\(Int(distance.rounded()))m"
    }
    
    func reset() {
        gameOverNode.removeFromParent()
        player.node.removeFromParent()
        status = .intro
        addChild(tutorialOverlay.node)
        player.reset()
        slalomSpawner.reset()
        
        points = 0
        pointsLabel.text = "\(points)"
        
        player.lives = 5
        livesLabel.text = "\(player.lives)"
        
        distance = 0.0
        distanceLabel.text = "\(Int(distance.rounded()))m"
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
                self.destX = currentX + CGFloat(data.acceleration.x * 30)
            }
        }
    }
    
    func setupSlalomSpawner() {
        slalomSpawner = SlalomSpawner(parent: self)
    }
    
    // MARK: Nodes contact methods
    
    func didBegin(_ contact: SKPhysicsContact) {
        // Filters possible contacts envolving the player
        // Player is either bodyA or bodyB
        if contact.bodyA.node?.name == "Player" {
            if contact.bodyB.node?.name == "Obstacle"{
                contactWithObstacle()
            }
            playerContact(with: contact.bodyB.node!)
        }
        else if contact.bodyB.node?.name == "Player" {
            if contact.bodyA.node?.name == "Obstacle"{
                contactWithObstacle()
            }
            playerContact(with: contact.bodyA.node!)
        }
    }
    
    // SKNode -> SKSpriteNode -> Slalom
    // node           ->         slalomNode
    
    func playerContact(with node: SKNode) {
        guard let slalomNode = node as! Slalom? else {
            print("não é um slalom")
            return
        }
        
        guard !slalomNode.wasHit else {
            return
        }
        
        if slalomNode.slalomType == player.stickColor {
            points += 1
            pointsLabel.text = "\(points)"
        } else {
            discountPlayerLife()
        }
        
        slalomNode.wasHit = true
    }
    
    func contactWithObstacle(obstacle: Obstacle) {
        player.lives -= 1
        // If player's position positive, we subtract
        if obstacle.position.x < 0 {
            player.node.position.x += 10
        } else {
            obstacle.position.x > 0
            player.node.position.x += 10
        }
     
        // If players's posiiton negative, we add
    }
    
    func discountPlayerLife() {
        player.lives -= 1
        
        if player.lives <= 0 {
            gameOver()
        } else {
            livesLabel.text = "\(player.lives)"
        }
    }
}

enum GameStatus {
    case intro
    case playing
    case paused
    case gameOver
}
