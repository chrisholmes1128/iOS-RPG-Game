//
//  GameScene.swift
//  rpgGame
//
//  Created by Mitchell Lam on 2/9/21.
//

import SpriteKit
import GameplayKit
import UIKit
import SwiftUI

class GameScene: SKScene {
    // MARK: - Instance Variables
    @Published var gameIsPaused = false {
        didSet {
            isPaused = gameIsPaused
        }
    }
    
    let playerSpeed: CGFloat = 150.0
    let playerDashDistance: CGFloat = 150.0
    let zombieSpeed: CGFloat = 75.0
    
    var player: SKSpriteNode?
    var zombies: [SKSpriteNode] = []
    
    var joyStickAnchor: CGPoint? = nil
    var touchTime = NSDate()
    
    override func sceneDidLoad() {
        // Setup player
        player = self.childNode(withName: "player") as? SKSpriteNode
        // Setup zombies
        for child in self.children {
            if child.name == "zombie" {
                if let child = child as? SKSpriteNode {
                    zombies.append(child)
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: view)
        joyStickAnchor = location
        touchTime = NSDate()
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: view)
        
        //calculations
        let angle = atan2(location.y - joyStickAnchor!.y, location.x - joyStickAnchor!.x) * -1
        let distance = sqrt(pow(location.x - joyStickAnchor!.x, 2) + pow(location.y - joyStickAnchor!.y, 2))
        
        //character movement
        if distance != 0 {
            //rotation
            let rotateAction = SKAction.rotate(toAngle: angle + .pi / 2, duration: 0)
            player!.run(rotateAction)
            
            //velocity
            let newVelocity = CGVector(dx: playerSpeed * cos(angle), dy: playerSpeed * sin(angle))
            player!.physicsBody!.velocity = newVelocity
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: view)
        
        //elapsed time to determine Attack or Dash
        let elapsedTime = touchTime.timeIntervalSinceNow * -1
        
        //calculations
        let angle = atan2(location.y - joyStickAnchor!.y, location.x - joyStickAnchor!.x) * -1
        let distance = sqrt(pow(location.x - joyStickAnchor!.x, 2) + pow(location.y - joyStickAnchor!.y, 2))
        
        //character movement
        if distance != 0 && elapsedTime < 0.2 {
            //rotation
            let rotateAction = SKAction.rotate(toAngle: angle + .pi / 2, duration: 0)
            player!.run(rotateAction)
            
            //velocity
            let Dash = SKAction.moveBy(x: playerDashDistance * cos(angle), y: playerDashDistance * sin(angle), duration: 0.1)
            player!.run(Dash)
            
        } else {
            //Attack
            print("Attack")
        }
        
        joyStickAnchor = nil
        player!.physicsBody!.isResting = true
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        joyStickAnchor = nil
        player!.physicsBody!.isResting = true
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func updateCamera() {
    }
    
    func updatePlayer() {
    }
}
