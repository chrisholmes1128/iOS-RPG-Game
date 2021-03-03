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
    let playerSpeed: CGFloat = 150.0
    let playerDashDistance: CGFloat = 100.0
    var maxHealth: CGFloat = 100
    var health: CGFloat?
    var maxMana: CGFloat = 100
    var mana: CGFloat?
    var maxStamina: CGFloat = 100
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
        let animation = SKAction.moveBy(x: playerDashDistance * cos(angle), y: playerDashDistance * sin(angle), duration: 0.1)
        
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
    
    func Attack() {
        let comboTimer = 1.3
        let staminaCost:CGFloat = 20
        //reset if miss combo
        if currentAction == .attack1 && elapsedTime >= comboTimer {
            Idle()
        }
        // melee combo
        if(currentAction != .attack1 && elapsedTime > cooldown && stamina! >= staminaCost) {
            startTime = NSDate()
            cooldown = 0.8
            currentAction = .attack1
            stamina! -= staminaCost
            player!.run(SKAction(named: "warrior_attack1")!)
        } else if (currentAction == .attack1 && elapsedTime > cooldown && elapsedTime < comboTimer && stamina! >= staminaCost) {
            startTime = NSDate()
            cooldown = 0.8
            currentAction = .attack2
            stamina! -= staminaCost
            player!.run(SKAction(named: "warrior_attack2")!)
        }
    }
    
    func hit(damage: CGFloat) {
        //stats
        health! -= damage
        startTime = NSDate()
        cooldown = 0.5
        
        // animation and sound
        player!.removeAllActions()
        player!.run(SKAction(named: "warrior_hit")!)
        currentAction = .hit
        
        // pinned and release after cooldown
        player!.physicsBody?.pinned = true
        DispatchQueue.main.asyncAfter(deadline: .now() + cooldown) { [self] in
            player!.physicsBody?.pinned = false
            Idle()
        }
    }
    
    func Idle() {
        currentAction = .idle
        player!.removeAllActions()
        player!.run(SKAction(named: "warrior_idle")!)
    }
    
    func UserInterface() {
        healthBar?.size.width = healthBarWidth! * health! / maxHealth
        staminaBar?.size.width = staminaBarWidth! * stamina! / maxStamina
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
        UserInterface()
        
        // action cooldown
        elapsedTime = startTime.timeIntervalSinceNow * -1
    }
}
