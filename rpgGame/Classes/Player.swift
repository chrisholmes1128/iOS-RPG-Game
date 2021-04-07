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
    var gameScene: GameScene
    var player: SKSpriteNode?
    private var healthBar: SKSpriteNode?
    private var healthBarWidth: CGFloat?
    private var staminaBar: SKSpriteNode?
    private var staminaBarWidth: CGFloat?
    private var scoreLabel: SKLabelNode?
    private var speechLabel = SKLabelNode(fontNamed:"Chalkduster")
    
    //stats
    var maxScore: Int = 1000
    var score: Int?
    private var scoreStartTime = NSDate()
    private var iframe: Double = 0.5 // invincible frame
    private var iframStartTime = NSDate()
    private var elapsedIframeTime: Double = 0.0
    private let attackDamage: CGFloat = 20
    private let attackRange: CGFloat = 100
    private let playerSpeed: CGFloat = 150.0
    private let playerDashDistance: CGFloat = 200.0
    private let maxHealth: CGFloat = 100
    private var health: CGFloat?
    private let maxMana: CGFloat = 100
    private var mana: CGFloat?
    private let maxStamina: CGFloat = 100
    private var stamina: CGFloat?
    var key:Bool = false
    
    //animations
    private var startTime = NSDate()
    private var cooldown: Double = 0.0
    private var elapsedTime: Double = 0.0
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
        self.gameScene = gameScene
        
        //physics
        player?.physicsBody?.isDynamic = true
        player?.physicsBody?.allowsRotation = false
        player?.physicsBody?.affectedByGravity = false
        player?.physicsBody?.restitution = 0
        player?.physicsBody?.categoryBitMask = bitMask.player
        player?.physicsBody?.collisionBitMask = bitMask.wall
        player?.physicsBody?.contactTestBitMask = bitMask.none
        
        //UI
        healthBar = gameScene.childNode(withName: "/camera/healthBar/health") as? SKSpriteNode
        healthBarWidth = healthBar?.size.width
        staminaBar = gameScene.childNode(withName: "/camera/healthBar/stamina") as? SKSpriteNode
        staminaBarWidth = staminaBar?.size.width
        gameScene.addChild(speechLabel)
        speechLabel.fontSize = 30
        speechLabel.alpha = 0
        
        //Score
        self.score = self.maxScore
        scoreLabel = SKLabelNode(fontNamed:"Chalkduster")
        scoreLabel!.text = "Score: " + String(score!)
        scoreLabel!.fontSize = 50
        scoreLabel!.position = gameScene.camera!.position
        scoreLabel!.position.y += gameScene.size.height / 2 - 100
        gameScene.camera!.addChild(scoreLabel!)
        
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
        let animation = SKAction.moveBy(x: playerDashDistance * cos(angle), y: playerDashDistance * sin(angle), duration: 0.3)
        
        //animation
        startTime = NSDate()
        cooldown = 1.0
        currentAction = .dash
        player!.removeAllActions()
        player!.run(SKAction(named: "warrior_dash")!)
        player!.run(animation)
        //back to idle after dash
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
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
                        if (enemy!.TargetDistance() <= attackRange && enemy?.currentAnimation != .death && currentAction == .attack1) {
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
                        if (enemy!.TargetDistance() <= attackRange && enemy?.currentAnimation != .death && currentAction == .attack2) {
                            enemy!.hit(damage: attackDamage)
                        }
                    }
                }
            }
        }
    }
    
    func hit(damage: CGFloat, staggerTimer: Double) {
        if elapsedIframeTime > iframe {
            //stats
            health! -= damage
            startTime = NSDate()
            iframStartTime = NSDate()
            elapsedIframeTime = 0
            cooldown = staggerTimer
            
            // gameover if health < 0
            if(health! <= 0) {
                Death()
                return
            }
            
            //speech
            SpeechBubble(text: "Ouch!")
            
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
    }
    
    func Idle() {
        currentAction = .idle
        player!.removeAllActions()
        player!.run(SKAction(named: "warrior_idle")!)
    }
    
    func Death() {
        //animation and physics
        if(currentAction != .death){
            player!.zPosition = -1
            player!.removeAllActions()
            player!.physicsBody?.isResting = true
            player!.run(SKAction(named: "warrior_death")!)
        }
        //status
        health = 0
        currentAction = .death
        gameScene.currentGameState = .gameOver
        gameScene.gameOver()
        
        //update gui
        UserInterface()
        
        //speech
        SpeechBubble(text: "Is This The End...")
    }
    
    func UserInterface() {
        // Health/Stamina
        healthBar?.size.width = healthBarWidth! * health! / maxHealth
        staminaBar?.size.width = staminaBarWidth! * stamina! / maxStamina
        
        //speech bubble
        speechLabel.position = player!.position
        speechLabel.position.y += (player?.size.height)! * 0.4
        
        //Score
        score = maxScore - Int(scoreStartTime.timeIntervalSinceNow * -1)
        scoreLabel!.text = "Score: " + String(Int(score!))
    }
    
    func SpeechBubble(text: String) {
        speechLabel.removeAllActions()
        speechLabel.text = text
        speechLabel.alpha = 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            let fadeout = SKAction.fadeOut(withDuration: 2)
            speechLabel.run(fadeout)
        }
    }
    
    func Update() {
        //UI
        UserInterface()
        
        // health & stamina regen
        if(currentAction == .idle) {
            if(health! < maxHealth){
                //health! += 0.05
            }
            if(stamina! < maxStamina){
                stamina! += 0.2
            }
        } else {
            if(stamina! < maxStamina){
                stamina! += 0.05
            }
        }
        
        // cooldown
        elapsedTime = startTime.timeIntervalSinceNow * -1
        elapsedIframeTime = iframStartTime.timeIntervalSinceNow * -1
    }
}
