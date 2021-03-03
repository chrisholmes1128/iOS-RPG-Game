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

class GameScene: SKScene, SKPhysicsContactDelegate {
    // MARK: - Instance Variables
    @Published var gameIsPaused = false {
        didSet {
            isPaused = gameIsPaused
        }
    }
    
    var joystick: SKSpriteNode?
    var joystickHandle: SKSpriteNode?
    var player:Player?
    var enemies: [Enemy?] = []
    
    var touchTime = NSDate()
    
    override func sceneDidLoad() {
        //resize scene base on device
        self.scaleMode = .aspectFit
        // Setup joystick
        joystick = self.childNode(withName: "joystick") as? SKSpriteNode
        joystickHandle = joystick?.children.first(where: {$0.name == "joystickHandle"}) as? SKSpriteNode
        joystick?.alpha = 0
        // Setup player
        player = Player(gameScene: self)
        // Setup skeleton
        for child in self.children {
            if child.name == "skeleton" {
                if let child = child as? SKSpriteNode {
                    //enemies.append(Skeleton(enemy: child, target: self.player!))
                }
            } else if child.name == "wolf" {
                if let child = child as? SKSpriteNode {
                    enemies.append(Wolf(enemy: child, target: self.player!))
                }
            }
        }
        //Set physics contact delegate
        physicsWorld.contactDelegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        
        //joystick
        joystick?.position = location
        joystick?.alpha = 1
        
        touchTime = NSDate()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        let joystickHandleLocation = touch.location(in: joystick!)
        
        //calculations
        let angle = atan2(location.y - joystick!.position.y, location.x - joystick!.position.x)
        let distance = sqrt(pow(location.x - joystick!.position.x, 2) + pow(location.y - joystick!.position.y, 2))
        
        //joystick
        joystickHandle?.position = joystickHandleLocation
        
        //character movement
        if distance != 0 {
            //velocity
            player!.Move(angle: angle, touch: location, joystick: joystick!)
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        //let location = touch.location(in: view)
        let joystickHandleLocation = touch.location(in: joystick!)
        
        //elapsed time to determine Attack or Dash
        let elapsedTime = touchTime.timeIntervalSinceNow * -1
        
        //calculations
        let angle = atan2(joystickHandleLocation.y, joystickHandleLocation.x)
        let distance = sqrt(pow(joystickHandleLocation.x, 2) + pow(joystickHandleLocation.y, 2))
        
        //character movement
        if elapsedTime < 0.2 {
            if distance >= 1.5{
                player!.Dash(angle: angle, touch: joystickHandleLocation, joystick: joystick!)
            } else {
                player!.Attack(enemies: self.enemies)
            }
        } else {
            //idle
            player!.Idle()
        }
        
        //reset
        joystick?.alpha = 0
        joystickHandle?.position = CGPoint(x:0, y:0)
        player!.player!.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
        
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        player!.Update()
        
        for enemy in enemies {
            enemy?.Update()
        }
        
        updateCamera()
    }
    
    func updateCamera() {
        //camera?.position = player!.position
    }
}
