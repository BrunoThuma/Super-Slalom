import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    static var sharedInstance: GameScene!
    weak var gameViewController: GameViewController!
    
    var status: GameStatus = .intro
    
    private var player: Player!
    private var slalomSpawner: SlalomSpawner!
    private var obstacleSpawner: ObstacleSpawner!
    
    private var points: Int = 0
    private var distance: Float = 0
    
    private var didDeslizouDezena = false
    private var didDeslizouCentena = false
    
    private var hub: SKNode!
    private var pinkButton: SKSpriteNode!
    private var blueButton: SKSpriteNode!
    private var pointsLabel: SKLabelNode!
    private var livesLabel: SKLabelNode!
    private var distanceLabel: SKLabelNode!
    private var pausedLabel: SKLabelNode!
    private var caraDeslizante: SKSpriteNode!
    private var distanceHub: SKSpriteNode!
    
    private var gameOverNode: SKNode!
    private var tutorialOverlay: TutorialNode!
    
    private var lastUpdate = TimeInterval(0)
    private var timeOutStart = TimeInterval(0)
    
    private var motionManager: CMMotionManager!
    private var destX: CGFloat!
    
    let audioPlayer = SuperSlalomAudioPlayer.shared
    
    var difficultyScale: CGFloat = 2.5
    
    // MARK: Overriden methods
    
    override func didMove(to view: SKView) {
        view.showsPhysics = false
        
        physicsWorld.contactDelegate = self
        
        GameScene.sharedInstance = self
        
        // Setup player
        let playerNode = (self.childNode(withName: "Player") as! SKSpriteNode)
        player = Player(node: playerNode, parentNode: self)
        
        // Setup tree on the side of playable area
        obstacleSpawner = ObstacleSpawner(parent: self)
        
        // Setup labels
        hub = self.childNode(withName: "HUB")
        pointsLabel = (hub.childNode(withName: "PointsLabel") as! SKLabelNode)
        pointsLabel.fontName = "Rubik-Bold"
        livesLabel = (hub.childNode(withName: "LivesLabel") as! SKLabelNode)
        livesLabel.fontName = "Rubik-Bold"
        distanceLabel = (hub.childNode(withName: "DistanceLabel") as! SKLabelNode)
        distanceLabel.fontName = "Rubik-Bold"
        distanceHub = (hub.childNode(withName: "DistanceHub") as! SKSpriteNode)
        caraDeslizante = (hub.childNode(withName: "CaraDeslizante") as! SKSpriteNode)
        
        let introNode = (childNode(withName: "Tutorial") as! SKSpriteNode)
        tutorialOverlay = TutorialNode(node: introNode)
        
        // Setup game over and remove from screen for now
        gameOverNode = self.childNode(withName: "GameOver")
        gameOverNode.position = CGPoint(x: 0, y: 0)
        gameOverNode.removeFromParent()
        
        pausedLabel = (childNode(withName: "PausedLabel") as! SKLabelNode)
        pausedLabel.removeFromParent()
        
        pinkButton = (self.childNode(withName: "RedSlalomButton") as! SKSpriteNode)
        blueButton = (self.childNode(withName: "BlueSlalomButton") as! SKSpriteNode)
        
        // Setup tutorial overlay animation
        tutorialOverlay.setupAnimation()
        
        // Setup slalom spawner
        slalomSpawner = SlalomSpawner(parent: self)
        
        setupMotionManager()
        
        setupMusic()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        switch status {
        case .intro:
            verifyTouchesIntroStatus(touches: touches)
        case .playing:
            verifyTouchesPlayingStatus(touches: touches)
        case .paused:
            unpauseGame()
        case .gameOver:
            verifyTouchesGameOverStatus(touches: touches)
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
            player.move(destX)
        case .playing:
            playingStatusUpdate(currentTime: currentTime, deltaTime: deltaTime)
        case .paused:
            break
        case .gameOver:
            break
        }
        
    }
    
    // MARK: Sound managing methods
    
    func setupMusic() {
        self.addChild(audioPlayer)
    }
    
    
    // MARK: Intro status methods
    
    func start() {
        status = .playing
        
        // Setup difficulty increaser
        difficultyScale = 2.5
        setupDifficultyIncreaser()
        
        tutorialOverlay.node.removeFromParent()
    }
    
    func verifyTouchesIntroStatus(touches: Set<UITouch>) {
        
        for touch in touches {
            
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            switch touchedNode {
            case pinkButton:
                player.changeStickColor(color: .red)
                pinkButton.run(
                    SKAction.animate(
                        with: [
                            SKTexture(imageNamed: "pinkbuttonpressed"),
                            SKTexture(imageNamed: "pinkbuttonnormal")],
                        timePerFrame: 0.5))
            case blueButton:
                player.changeStickColor(color: .blue)
                blueButton.run(
                    SKAction.animate(
                        with: [
                            SKTexture(imageNamed: "bluebuttonpressed"),
                            SKTexture(imageNamed: "bluebuttonnormal")],
                        timePerFrame: 0.5))
            default:
                start()
            }
        }
    }
    
    // MARK: Playing status methods
    
    func verifyTouchesPlayingStatus(touches: Set<UITouch>) {
        
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
            
            audioPlayer.runSkiingSound()
        }
    }
    
    
    func playingStatusUpdate(currentTime: TimeInterval, deltaTime: TimeInterval) {
        // Update time on slalomSpawner and obstacleSpawner
        slalomSpawner.update(deltaTime: deltaTime, difficultyScale: difficultyScale)
        obstacleSpawner.update(deltaTime: deltaTime, difficultyScale: difficultyScale)
        
        if currentTime - timeOutStart > 0.5 {
            player.move(destX)
        }
        
        distance += Float(deltaTime) * Float(difficultyScale - 0.5)
        
        distanceLabel.text = "\(Int(distance.rounded()))m"
        if distance > 9 && !didDeslizouDezena {
            distanceHub.position.x -= caraDeslizante.size.width * 0.12
            distanceLabel.position.x -= caraDeslizante.size.width  * 0.10
            didDeslizouDezena = true
            hub.position.x += caraDeslizante.size.width * 0.12
        }
        if distance > 99 && !didDeslizouCentena {
            distanceHub.position.x -= caraDeslizante.size.width / 2
            distanceLabel.position.x -= caraDeslizante.size.width  * 3 / 7
            didDeslizouCentena = true
            hub.position.x += (caraDeslizante.size.width / 2) - 0.012

        }
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
        self.removeAllActions()
        
        hub.removeFromParent()
        pinkButton.removeFromParent()
        blueButton.removeFromParent()
        
        status = .gameOver
        slalomSpawner.gameOver()
        addChild(gameOverNode)
        
        
        let gameOverPoints = gameOverNode.childNode(withName: "GameOverPointsLabel") as! SKLabelNode
        let gameOverDistance = gameOverNode.childNode(withName: "GameOverDistanceLabel") as! SKLabelNode
        
        gameOverPoints.fontName = "Rubik-SemiBold"
        gameOverPoints.fontSize = 26
        
        gameOverDistance.fontName = "Rubik-SemiBold"
        gameOverDistance.fontSize = 26
        
        gameOverPoints.text = "\(points)"
        gameOverDistance.text = "\(Int(distance.rounded()))m"
        
        GameCenterManager.shared.updateGameCenterScore(with: points)
        
    }
    
    func reset() {
        addChild(hub)
        addChild(pinkButton)
        addChild(blueButton)
        
        gameOverNode.removeFromParent()
        
        status = .intro
        addChild(tutorialOverlay.node)
        player.reset()
        
        slalomSpawner.reset()
        obstacleSpawner.reset()
        
        points = 0
        pointsLabel.text = "\(points)"
        
        player.lives = 5
        livesLabel.text = "\(player.lives)"
        
        distance = 0.0
        distanceLabel.text = "\(Int(distance.rounded()))m"
        
        distanceHub.position.x = -97
        distanceLabel.position.x = -97

    }
    
    func verifyTouchesGameOverStatus(touches: Set<UITouch>) {
        for touch in touches {
            
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            switch touchedNode.name {
            case "GameOverRestartButton":
                gameViewController.restartGame()
            case "GameOverHomeButton":
                gameViewController.goToMainMenu()
            default:
                break
            }
        }
    }
    
    // MARK: Setup methods
    
    private func setupDifficultyIncreaser() {
        let increaseDifficultyList = [SKAction.wait(forDuration: 1),
                                          SKAction.run {
            self.difficultyScale += 0.025
        }
        ]
        let increaseDifficultySequence = SKAction.sequence(increaseDifficultyList)
        let increaseDifficultyLoop = SKAction.repeatForever(increaseDifficultySequence)
        
        self.run(increaseDifficultyLoop)
    }
    
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
            // Filter contact with obstacle on side of track
            if let obstacleNode = contact.bodyB.node as? Obstacle {
                contactWithObstacle(obstacle: obstacleNode)
            } else {
                playerContact(with: contact.bodyB.node!)
            }
        }
        else if contact.bodyB.node?.name == "Player" {
            if let obstacleNode = contact.bodyB.node as? Obstacle {
                contactWithObstacle(obstacle: obstacleNode)
            } else {
                playerContact(with: contact.bodyA.node!)
            }
        }
    }
    
    func playerContact(with node: SKNode) {
        guard let slalomNode = node as! Slalom? else {
            return
        }
        
        guard !slalomNode.wasHit else {
            return
        }
        
        if slalomNode.slalomType == player.stickColor {
            points += 1
            pointsLabel.text = "\(points)"
            
            audioPlayer.runRightFlagSound()
//            run(hitRightFlagSound)
            
            slalomNode.setupWasHitAnimation()
        } else {
            discountPlayerLife()
            
            audioPlayer.runWrongFlagSound()
//            run(hitWrongFlagSound)
        }
        
        slalomNode.wasHit = true
    }
    
    func contactWithObstacle(obstacle: Obstacle) {
        
        timeOutStart = self.lastUpdate
        // FIXME: Why player not moving?
        player.move(0)
        
        audioPlayer.runHitTreeSound()
//        run(hitTreeSound)
        
    }
    
    func discountPlayerLife() {
        player.lives -= 1
        livesLabel.text = "\(player.lives)"
        
        if player.lives <= 0 {
            gameOver()
        }
    }
    
}

enum GameStatus {
    case intro
    case playing
    case paused
    case gameOver
}
