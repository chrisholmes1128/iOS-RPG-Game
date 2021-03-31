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

struct bitMask {
    static let none:UInt32 = 0x00000000
    static let player:UInt32 = 0x00000001
    static let enemy:UInt32 = 0x00000010
    static let projectile:UInt32 = 0x00000011
    static let wall:UInt32 = 0x00000100
}

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
    var tileMap: SKTileMapNode?
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
        self.tileMap = self.childNode(withName: "room") as? SKTileMapNode
        tileMapCollision(tileMap: self.tileMap!)
        objects = self.childNode(withName: "/room/objects") as? SKTileMapNode
        tileMapCollision(tileMap: objects!)
        
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
        if nodeA.name == nil || nodeB.name == nil {
            return
        }
        
        projectileCollision(nodeA: nodeA, nodeB: nodeB)
        doorCollision(nodeA: nodeA, nodeB: nodeB)
    }
    
    func projectileCollision(nodeA: SKNode, nodeB: SKNode) {
        if nodeA.name == "player" {
            for enemy in enemies {
                if enemy?.projectileName == nodeB.name {
                    if player?.currentAction != .death {
                        print("hit")
                        player!.hit(damage: enemy!.attackDamage!, staggerTimer: enemy!.attackStagger!)
                        nodeB.removeFromParent()
                        return
                    }
                }
            }
        } else if nodeA.name == "wall" {
            nodeB.removeFromParent()
        }
    }
    
    func doorCollision(nodeA: SKNode, nodeB: SKNode) {
        if nodeA.name == "player" && nodeB.name == "door" && player!.key {
            nodeB.removeFromParent()
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
    
    func tileMapCollision(tileMap: SKTileMapNode) {
        let tileSize = tileMap.tileSize
        let halfWidth = CGFloat(tileMap.numberOfColumns) / 2.0 * tileSize.width
        let halfHeight = CGFloat(tileMap.numberOfRows) / 2.0 * tileSize.height

        for col in 0..<tileMap.numberOfColumns {
            for row in 0..<tileMap.numberOfRows {
                let tileDefinition = tileMap.tileDefinition(atColumn: col, row: row)
                let isEdgeTile = tileDefinition?.userData?["edgeTile"] as? Bool
                let isDoorTile = tileDefinition?.userData?["door"] as? Bool
                if (isEdgeTile ?? false) || (isDoorTile ?? false) {
                    let x = CGFloat(col) * tileSize.width - halfWidth
                    let y = CGFloat(row) * tileSize.height - halfHeight
                    let rect = CGRect(x: 0, y: 0, width: tileSize.width, height: tileSize.height)
                    let tileNode = SKShapeNode(rect: rect)
                    tileNode.name = "wall"
                    if isDoorTile ?? false {
                        tileNode.name = "door"
                    }
                    tileNode.position = CGPoint(x: x, y: y)
                    tileNode.physicsBody = SKPhysicsBody.init(rectangleOf: tileSize, center: CGPoint(x: tileSize.width / 2.0, y: tileSize.height / 2.0))
                    tileNode.physicsBody?.isDynamic = false
                    tileNode.physicsBody?.restitution = 0
                    tileNode.physicsBody?.categoryBitMask = bitMask.wall
                    tileNode.physicsBody?.contactTestBitMask = bitMask.player
                    tileMap.addChild(tileNode)
                }
            }
        }
    }
    
    func objectDetection() {
        let position = convert((player?.player!.position)!, to: objects!)
        let column = objects?.tileColumnIndex(fromPosition: position)
        let row = (objects?.tileRowIndex(fromPosition: position))! - 1
        let tile = objects?.tileDefinition(atColumn: column!, row: row)
        
        //handle interaction
        if let _ = tile?.userData?.value(forKey: "spikeTrap") {
            player?.hit(damage: 5, staggerTimer: 0.2)
        } else if let _ = tile?.userData?.value(forKey: "silverKey") {
            objects?.setTileGroup(nil, forColumn: column!, row: row)
            player?.key = true
            
            //sound effect
            let sfx = SKAction.playSoundFileNamed("key_pickup.mp3", waitForCompletion: false)
            player!.player!.run(sfx)
        } else if tile?.userData?.value(forKey: "door") != nil && player!.key {
            objects?.setTileGroup(nil, forColumn: column!, row: row)
        } else if tile?.userData?.value(forKey: "silverChest") != nil && player!.key {
            let tileSet = SKTileSet(named: "dungeon_tools")
            objects?.setTileGroup(tileSet?.tileGroups[4], forColumn: column!, row: row)
            player?.maxScore += tile?.userData?.value(forKey: "score") as! Int
            
            // sound effect
            let sfx = SKAction.playSoundFileNamed("chest_open_gold.mp3", waitForCompletion: false)
            player!.player!.run(sfx)
        }
    }
}
