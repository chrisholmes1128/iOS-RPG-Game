//
//  Skeleton.swift
//  rpgGame
//
//  Created by Mitchell Lam on 2/17/21.
//

import SpriteKit

class Enemy {
    //textures
    var enemy: SKSpriteNode?
    var target: Player?
    var healthBar: SKSpriteNode?
    var healthBarWidth: CGFloat?
    
    //stats
    var name: String?
    var moveSpeed: CGFloat?
    var maxHealth: CGFloat?
    var health: CGFloat?
    var attackRange: CGFloat?
    var attackHitFrame: Double? // the time that attack actual hits
    var attackDamage: CGFloat?
    
    //animations
    var startTime = NSDate()
    var cooldown: Double = 0.0
    var elapsedTime: Double = 0.0
    var currentAction = Action.idle
    enum Action {
        case idle
        case walk
        case run
        case hit
        case attack1
        case attack2
        case death
    }
    
    init(enemy: SKSpriteNode, target: Player) {
        self.enemy = enemy
        self.target = target
        self.healthBar = enemy.children.first(where: {$0.name == "health"}) as? SKSpriteNode
        self.healthBarWidth = self.healthBar?.size.width
        self.healthBar?.alpha = 0
    }
    
    func TargetDistance() -> CGFloat{
        let distance = sqrt(pow((target!.player?.position.x)! - (enemy?.position.x)!, 2) + pow((target!.player?.position.y)! - (enemy?.position.y)!, 2))
        return distance
    }
    
    func TargetAngle() -> CGFloat{
        let angle = atan2((target!.player?.position.y)! - (enemy?.position.y)!, (target!.player?.position.x)! - (enemy?.position.x)!)
        return angle
    }
    
    func Move(){
        //calculations
        let angle = TargetAngle()
        let newVelocity = CGVector(dx: moveSpeed! * cos(angle), dy: moveSpeed! * sin(angle))
        enemy!.physicsBody!.velocity = newVelocity
        
        //direction
        let direction:CGFloat
        if((target!.player?.position.x)! < (enemy?.position.x)!) {
            direction = -1.0
        } else {
            direction = 1.0
        }
        enemy?.xScale = abs(enemy!.xScale) * direction
        enemy!.physicsBody?.pinned = false
        
        //animation
        if(currentAction != .walk){
            enemy!.removeAllActions()
            enemy!.run(SKAction(named: name! + "_walk")!)
            currentAction = .walk
        }
    }
    
    func Attack() {
        //stats
        startTime = NSDate()
        cooldown = attackHitFrame! * 3.0

        //animations
        currentAction = .attack1
        enemy!.removeAllActions()
        enemy!.run(SKAction(named: name! + "_attack1")!)
        enemy!.physicsBody?.pinned = true
        
        //hit check
        DispatchQueue.main.asyncAfter(deadline: .now() + attackHitFrame!) { [self] in
            if(TargetDistance() <= attackRange! && currentAction == .attack1){
                target?.hit(damage: attackDamage!)
            }
        }
    }
    
    func Death() {
        //animation and physics
        if(currentAction != .death){
            enemy!.zPosition = -1
            enemy!.removeAllActions()
            enemy!.physicsBody?.isResting = true
            enemy!.run(SKAction(named: name! + "_death")!)
        }
        //status
        health = 0
        currentAction = .death
        
    }
    
    func Idle() {
        //animation
        enemy!.removeAllActions()
        enemy!.run(SKAction(named: name! + "_idle")!)
    }
    
    func UserInterface() {
        //health bar
        if(health! < maxHealth!){
            healthBar?.alpha = 1
            healthBar?.size.width = healthBarWidth! * health! / maxHealth!
        } else {
            healthBar?.alpha = 0
        }
    }
    
    func Update() {
        //death
        if(health! <= 0) {
            Death()
            return
        }
        
        //UI
        UserInterface()
        
        // movements
        if(elapsedTime > cooldown) {
            if TargetDistance() <= attackRange! {
                Attack()
            } else if !(enemy!.hasActions()) {
                Idle()
            } else {
                Move()
            }
        }
        
        // animation cooldown timer
        elapsedTime = startTime.timeIntervalSinceNow * -1
    }
}
