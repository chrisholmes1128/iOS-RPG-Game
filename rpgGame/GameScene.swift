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
    
    //nodes
    var joystick: SKSpriteNode?
    var joystickHandle: SKSpriteNode?
    var player:Player?
    var enemies: [Enemy?] = []
    let music = SKAudioNode(fileNamed: "Everlasting-Snow.mp3")
    var background: SKTileMapNode?
    var objects: SKTileMapNode?
    
    //stats
    var touchTime = NSDate()
    var currentGameState = gameState.playing
    enum gameState {
        case gameOver
        case paused
        case playing
    }
    
    override func sceneDidLoad() {
        //resize scene base on device
        self.scaleMode = .aspectFit
        
        //physics world
        physicsWorld.contactDelegate = self
        
        // background music
        addChild(music)
        
        // Setup joystick
        joystick = self.childNode(withName: "/camera/joystick") as? SKSpriteNode
        joystickHandle = self.childNode(withName: "/camera/joystick/joystickHandle") as? SKSpriteNode
        joystick?.alpha = 0
        
        // setup tile maps
        background = self.childNode(withName: "/room") as? SKTileMapNode
        objects = self.childNode(withName: "/room/objects") as? SKTileMapNode
        
        // Setup player
        player = Player(gameScene: self)
        
        // Setup enemies
        for child in self.children {
            if child.name == "skeleton" {
                if let child = child as? SKSpriteNode {
                    enemies.append(Skeleton(gameScene:self, enemy: child, target: self.player!))
                }
            } else if child.name == "wolf" {
                if let child = child as? SKSpriteNode {
                    enemies.append(Wolf(gameScene:self, enemy: child, target: self.player!))
                }
            } else if child.name == "bat" {
                if let child = child as? SKSpriteNode {
                    enemies.append(Bat(gameScene:self, enemy: child, target: self.player!))
                }
            } else if child.name == "witch" {
                if let child = child as? SKSpriteNode {
                    enemies.append(Witch(gameScene:self, enemy: child, target: self.player!))
                }
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // Handle the collitions in each nodes class
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        projectileCollision(nodeA: nodeA, nodeB: nodeB)
    }
    
    func projectileCollision(nodeA: SKNode, nodeB: SKNode) {
        if nodeA.name == "player" {
            for enemy in enemies {
                if enemy?.projectileName == nodeB.name {
                    if player?.currentAction != .death {
                        player!.hit(damage: enemy!.attackDamage!, staggerTimer: enemy!.attackStagger!)
                        nodeB.removeFromParent()
                    }
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self.camera!)
        
        //joystick
        joystick?.position = location
        joystick?.alpha = 1
        
        touchTime = NSDate()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self.camera!)
        let joystickHandleLocation = touch.location(in: joystick!)
        
        //calculations
        let angle = atan2(location.y - joystick!.position.y, location.x - joystick!.position.x)
        let distance = sqrt(pow(location.x - joystick!.position.x, 2) + pow(location.y - joystick!.position.y, 2))
        
        //joystick
        joystickHandle?.position = joystickHandleLocation
        
        //disable player control when gameover or hit
        if currentGameState == .gameOver || player?.currentAction == .hit {
            return
        }
        
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
        
        //disable player control when gameover or hit
        if currentGameState == .gameOver || player?.currentAction == .hit {
            return
        }

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
        
        // gameover
        if currentGameState == .gameOver {
            return
        }
        
        if player?.currentAction == .death {
            gameOver()
        }
        
        // if game is not paused
        if currentGameState != .paused {
            player!.Update()
            
            for enemy in enemies {
                enemy?.Update()
            }
            
            updateCamera()
        }
        
        // objects interaction
        objectDetection()
    }
    
    func updateCamera() {
        camera?.position = (player?.player!.position)!
    }
    
    func gameOver() {
        // gameover label on screen
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "GameOver!"
        myLabel.fontSize = 65
        myLabel.position = camera!.position
        self.addChild(myLabel)
        
        //game state
        currentGameState = .gameOver
        physicsWorld.speed = 0
        isUserInteractionEnabled = false
        music.removeFromParent()
    }
    
    func objectDetection() {
        let position = convert((player?.player!.position)!, to: objects!)
        let column = objects?.tileColumnIndex(fromPosition: position)
        let row = (objects?.tileRowIndex(fromPosition: position))! - 1
        let tile = objects?.tileDefinition(atColumn: column!, row: row)
        handleObject(tile: tile)
    }
    
    func handleObject(tile: SKTileDefinition?) {
        if tile == nil {
            return
        }
        if tile!.name == "peaks_1" {
            player?.hit(damage: 5, staggerTimer: 0.2)
        }
    }
}
