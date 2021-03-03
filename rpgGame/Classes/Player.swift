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
    var healthBar: SKSpriteNode?
    var healthBarWidth: CGFloat?
    var staminaBar: SKSpriteNode?
    var staminaBarWidth: CGFloat?
    
    let playerSpeed: CGFloat = 150.0
    let playerDashDistance: CGFloat = 100.0
    
    var maxHealth: CGFloat = 100
    var health: CGFloat?
    var maxMana: CGFloat = 100
    var mana: CGFloat?
    var maxStamina: CGFloat = 100
    var stamina: CGFloat?
    
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
    
    let hitSound: SKAction?
    
    init(gameScene: GameScene) {
        self.player = gameScene.childNode(withName: "player") as? SKSpriteNode
        self.health = self.maxHealth
        self.mana = self.maxMana
        self.stamina = self.maxStamina
        
        //UI
        let healthBarUI = gameScene.childNode(withName: "healthBar") as? SKSpriteNode
        healthBar = healthBarUI?.children.first(where: {$0.name == "health"}) as? SKSpriteNode
        healthBarWidth = healthBar?.size.width
        staminaBar = healthBarUI?.children.first(where: {$0.name == "stamina"}) as? SKSpriteNode
        staminaBarWidth = staminaBar?.size.width
        
        //Sounds
        hitSound = SKAction.playSoundFileNamed("body_hit.mp3", waitForCompletion: false)
    }
    
    func Move(angle: CGFloat, touch: CGPoint, joystick: SKSpriteNode) {
        // animation lock
        if(elapsedTime < cooldown){
            return
        }
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
        let staminaCost:CGFloat = 10

        // animation lock
        if(elapsedTime < cooldown ){
            return
        }
        // stamina limit
        if(stamina! < staminaCost) {
            return
        }
        
        //velocity
        let animation = SKAction.moveBy(x: playerDashDistance * cos(angle), y: playerDashDistance * sin(angle), duration: 0.1)
        
        //animation
        newAction = .dash
        player!.run(animation)
        startTime = NSDate()
        cooldown = 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
            newAction = .idle
        }
        
        //direction
        var direction:CGFloat
        if touch.x < joystick.position.x {
            direction = -1.0
        } else {
            direction = 1.0
        }
        player?.xScale = abs(player!.xScale) * direction
        stamina! -= staminaCost
    }
    
    func Attack() {
        let comboTimer = 1.3
        let staminaCost:CGFloat = 20
        //reset if miss combo
        if currentAction == .attack1 && elapsedTime >= comboTimer {
            currentAction = .idle
        }
        // melee combo
        if(currentAction != .attack1 && elapsedTime > cooldown && stamina! >= staminaCost) {
            startTime = NSDate()
            cooldown = 0.8
            newAction = .attack1
            stamina! -= staminaCost
        } else if (currentAction == .attack1 && elapsedTime > cooldown && elapsedTime < comboTimer && stamina! >= staminaCost) {
            startTime = NSDate()
            cooldown = 0.8
            newAction = .attack2
            stamina! -= staminaCost
        }
    }
    
    func hit(damage: CGFloat) {
        health! -= damage
        startTime = NSDate()
        cooldown = 0.5
        
        // animation and sound
        player!.removeAllActions()
        player!.run(SKAction(named: "warrior_hit")!)
        player!.run(hitSound!)
        newAction = .hit
        
        // pinned and release after cooldown
        player!.physicsBody?.pinned = true
        DispatchQueue.main.asyncAfter(deadline: .now() + cooldown) { [self] in
            player!.physicsBody?.pinned = false
        }
    }
    
    func Update() {
        // gameover if health < 0
        if(health! <= 0) {
            health = 0
        }
        // health & stamina regen
        if(health! < maxHealth && health! > 0){
            health! += 0.01
        }
        if(stamina! < maxStamina){
            stamina! += 0.1
        }
        
        //UI
        healthBar?.size.width = healthBarWidth! * health! * 0.01
        staminaBar?.size.width = staminaBarWidth! * stamina! * 0.01
        
        // action cooldown
        elapsedTime = startTime.timeIntervalSinceNow * -1
        
        //move if velocity > 0 else idle
        let normal = sqrt(pow((player!.physicsBody?.velocity.dx)!, 2) + pow((player!.physicsBody?.velocity.dy)!, 2))
        if(normal > 1){
            newAction = .run
        } else if(!player!.hasActions()) {
            newAction = .idle
        }
        
        //execute animation
        if newAction != currentAction{
            switch newAction {
            case .idle:
                player!.run(SKAction(named: "warrior_idle")!)
            case .run:
                player!.run(SKAction(named: "warrior_run")!)
            case .dash:
                player!.run(SKAction(named: "warrior_dash")!)
            case .hit:
                break
            case .attack1:
                player!.run(SKAction(named: "warrior_attack1")!)
            case .attack2:
                player!.run(SKAction(named: "warrior_attack2")!)
            case .death:
                player!.run(SKAction(named: "warrior_death")!)
            }
            currentAction = newAction
        }
    }
}
