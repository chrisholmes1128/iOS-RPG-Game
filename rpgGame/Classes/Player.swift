//
//  Player.swift
//  rpgGame
//
//  Created by Mitchell Lam on 2/17/21.
//

import SpriteKit
import GameplayKit

class Player {
    var player: SKSpriteNode?
    
    let playerSpeed: CGFloat = 150.0
    let playerDashDistance: CGFloat = 100.0
    
    var startTime = NSDate()
    var cooldown: Double = 0.0
    var elapsedTime: Double = 0.0
    var newAction = playerAction.idle
    var currentAction = playerAction.run
    enum playerAction {
        case idle
        case run
        case dash
        case hit
        case attack1
        case attack2
        case death
    }
    
    init(player: SKSpriteNode) {
        self.player = player
    }
    
    func Move(angle: CGFloat, touch: CGPoint, joystick: SKSpriteNode) {
        //velocity
        let newVelocity = CGVector(dx: playerSpeed * cos(angle), dy: playerSpeed * sin(angle))
        player!.physicsBody!.velocity = newVelocity
        
        //direction
        var direction:CGFloat
        if touch.x < joystick.position.x {
            direction = -1.0
        } else {
            direction = 1.0
        }
        player?.xScale = abs(player!.xScale) * direction
    }
    
    func Dash(angle: CGFloat, touch: CGPoint, joystick: SKSpriteNode) {
        //velocity
        let animation = SKAction.moveBy(x: playerDashDistance * cos(angle), y: playerDashDistance * sin(angle), duration: 0.1)
        
        //animation
        newAction = .dash
        player!.run(animation)
        
        //direction
        var direction:CGFloat
        if touch.x < joystick.position.x {
            direction = -1.0
        } else {
            direction = 1.0
        }
        player?.xScale = abs(player!.xScale) * direction
    }
    
    func Attack() {
        let comboTimer = 2.0
        //reset if miss combo
        if elapsedTime >= comboTimer {
            currentAction = .idle
        }
        // melee combo
        if(currentAction != .attack1 && elapsedTime > cooldown) {
            startTime = NSDate()
            cooldown = 0.8
            newAction = .attack1
        } else if (currentAction == .attack1 && elapsedTime > cooldown && elapsedTime < comboTimer) {
            startTime = NSDate()
            cooldown = 0.8
            newAction = .attack2
        }
    }
    
    func update() {
        // animation cooldown
        elapsedTime = startTime.timeIntervalSinceNow * -1
        
        //run if velocity > 0
        let normal = sqrt(pow((player!.physicsBody?.velocity.dx)!, 2) + pow((player!.physicsBody?.velocity.dy)!, 2))
        if(normal > 0){
            newAction = .run
        }
        
        //execute animation
        if newAction != currentAction {
            print(newAction)
            switch newAction {
            case .idle:
                player!.run(SKAction(named: "warrior_idle")!)
            case .run:
                player!.run(SKAction(named: "warrior_run")!)
            case .dash:
                player!.run(SKAction(named: "warrior_dash")!)
            case .hit:
                player!.run(SKAction(named: "warrior_hit")!)
            case .attack1:
                player!.run(SKAction(named: "warrior_attack1")!)
            case .attack2:
                player!.run(SKAction(named: "warrior_attack2")!)
            case .death:
                player!.run(SKAction(named: "warrior_death")!)
            }
            currentAction = newAction
        }
        
        //idle if stop running
        if(currentAction == .run && normal == 0){
            newAction = .idle
        }
    }
}
