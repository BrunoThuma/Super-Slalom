//
//  GameScene.swift
//  Super Slalom
//
//  Created by Bruno Thuma on 28/01/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var totalLifes: Int = 3
    
    var player: Player!
    var slalomSpawner: SlalomSpawner!
    
    var points: Int = 0
    var pointsLabel: SKLabelNode!
    
    var livesLabel: SKLabelNode!
    
    var lastUpdate = TimeInterval(0)
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        
        addSwipeGestureRecognizers()
        
        // Setup player
        let playerNode = (self.childNode(withName: "Player") as! SKSpriteNode)
        player = Player(node: playerNode)
        
        let redSlalomNode = (self.childNode(withName: "RedSlalom") as! SKSpriteNode)
        let blueSlalomNode = (self.childNode(withName: "BlueSlalom")  as! SKSpriteNode)
        slalomSpawner = SlalomSpawner(redSlalomModel: redSlalomNode,
                                      blueSlalomModel: blueSlalomNode,
                                      parent: self)
        
        pointsLabel = (self.childNode(withName: "PointsLabel") as! SKLabelNode)
        
        livesLabel = (self.childNode(withName: "LivesLabel") as! SKLabelNode)
        
        view.showsPhysics = false
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
    }
    
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
            livesLabel.text = String(repeating: "❤️", count: max(player.lives, 1))
        }
    }
    
    func addSwipeGestureRecognizers() {
        let gestureDirections: [UISwipeGestureRecognizer.Direction] = [.left, .right]
        
        for gestureDirection in gestureDirections {
            let gestureRecognizer = UISwipeGestureRecognizer(target: self,
                                                             action: #selector(handleSwipe))
            gestureRecognizer.direction = gestureDirection
            self.view?.addGestureRecognizer(gestureRecognizer)
        }
    }
    
    @objc func handleSwipe(gesture: UIGestureRecognizer) {
        if let gesture = gesture as? UISwipeGestureRecognizer {
//            switch gesture.direction {
//            case .left:
//                print("left")
//            case .right:
//                print("right")
//            default:
//                print("non treated swipe gesture")
//            }
            player.move(direction: gesture.direction)
        }
    }
}
