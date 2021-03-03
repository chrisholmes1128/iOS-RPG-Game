//
//  Player.swift
//  rpgGame
//
//  Created by Mitchell Lam on 2/17/21.
//

import SpriteKit
import GameplayKit

class Player {
    //textures
    var player: SKSpriteNode?
    var healthBar: SKSpriteNode?
    var healthBarWidth: CGFloat?
    var staminaBar: SKSpriteNode?
    var staminaBarWidth: CGFloat?
    
    //stats
    let attackDamage: CGFloat = 20
    let attackRange: CGFloat = 100
    let playerSpeed: CGFloat = 150.0
    let playerDashDistance: CGFloat = 100.0
    let maxHealth: CGFloat = 100
    var health: CGFloat?
    let maxMana: CGFloat = 100
    var mana: CGFloat?
    let maxStamina: CGFloat = 100
    var stamina: CGFloat?
    
    //animations
    var startTime = NSDate()
    var cooldown: Double = 0.0
    var elapsedTime: Double = 0.0
    var currentAction = playerAction.idle
    enum playerAction {
        case idle
        case run
        case dash
        case hit
        case attack1
        case attack2
        case death
    }
    
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
        
        //animation
        Idle()
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
        
        //animation
        if(currentAction != .run){
            player!.removeAllActions()
            player!.run(SKAction(named: "warrior_run")!)
            currentAction = .run
        }
    }
    
    func Dash(angle: CGFloat, touch: CGPoint, joystick: SKSpriteNode) {
        let staminaCost:CGFloat = 10
        
        // animation lock
        if(elapsedTime < cooldown){
            return
        }
        // stamina limit
        if(stamina! < staminaCost) {
            return
        }
        
        //velocity
        let animation = SKAction.moveBy(x: playerDashDistance * cos(angle), y: playerDashDistance * sin(angle), duration: 0.2)
        
        //animation
        startTime = NSDate()
        cooldown = 0.5
        currentAction = .dash
        player!.removeAllActions()
        player!.run(SKAction(named: "warrior_dash")!)
        player!.run(animation)
        //back to idle after dash
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [self] in
            Idle()
        }
        
        //direction
        var direction:CGFloat
        if touch.x < joystick.position.x {
            direction = -1.0
        } else {
            direction = 1.0
        }
        player?.xScale = abs(player!.xScale) * direction
        
        //stat
        stamina! -= staminaCost
    }
    
    func Attack(enemies: [Enemy?]) {
        //stats
        let comboTimer = 1.3
        let staminaCost:CGFloat = 10
        cooldown = 0.8
        
        //reset if miss combo
        if currentAction == .attack1 && elapsedTime >= comboTimer {
            Idle()
        }
        
        // melee combo
        if(elapsedTime > cooldown && stamina! >= staminaCost) {
            //stats
            startTime = NSDate()
            stamina! -= staminaCost
            
            //animation
            if(currentAction != .attack1) {
                currentAction = .attack1
                player!.run(SKAction(named: "warrior_attack1")!)
                //hit check
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [self] in
                    for enemy in enemies {
                        if (enemy!.TargetDistance() <= attackRange && enemy?.currentAction != .death && currentAction == .attack1) {
                            enemy!.hit(damage: attackDamage)
                        }
                    }
                }
            } else if (currentAction == .attack1 && elapsedTime < comboTimer) {
                currentAction = .attack2
                player!.run(SKAction(named: "warrior_attack2")!)
                //hit check
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
                    for enemy in enemies {
                        if (enemy!.TargetDistance() <= attackRange && enemy?.currentAction != .death && currentAction == .attack2) {
                            enemy!.hit(damage: attackDamage)
                        }
                    }
                }
            }
        }
    }
    
    func hit(damage: CGFloat, staggerTimer: Double) {
        //stats
        health! -= damage
        startTime = NSDate()
        cooldown = staggerTimer
        
        // gameover if health < 0
        if(health! <= 0) {
            Death()
            return
        }
        
        // animation
        player!.removeAllActions()
        player!.run(SKAction(named: "warrior_hit")!)
        currentAction = .hit
        
        // pinned and release after cooldown
        player!.physicsBody?.pinned = true
        DispatchQueue.main.asyncAfter(deadline: .now() + cooldown) { [self] in
            if(currentAction != .death){
            player!.physicsBody?.pinned = false
            Idle()
            }
        }
    }
    
    func Idle() {
        currentAction = .idle
        player!.removeAllActions()
        player!.run(SKAction(named: "warrior_idle")!)
    }
    
    func Death() {
        //animation and physics
        if(currentAction != .death){
            print("death")
            player!.zPosition = -1
            player!.removeAllActions()
            player!.physicsBody?.isResting = true
            player!.run(SKAction(named: "warrior_death")!)
        }
        //status
        health = 0
        currentAction = .death
    }
    
    func UserInterface() {
        healthBar?.size.width = healthBarWidth! * health! / maxHealth
        staminaBar?.size.width = staminaBarWidth! * stamina! / maxStamina
    }
    
    func Update() {
        //UI
        UserInterface()
        
        // dead
        if(health! <= 0) {
            return
        }
        
        // health & stamina regen
        if(currentAction == .idle) {
            if(health! < maxHealth){
                health! += 0.05
            }
            if(stamina! < maxStamina){
                stamina! += 0.5
            }
        } else {
            if(stamina! < maxStamina){
                stamina! += 0.1
            }
        }
        
        // action cooldown
        elapsedTime = startTime.timeIntervalSinceNow * -1
    }
}
