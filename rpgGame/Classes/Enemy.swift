//
//  Skeleton.swift
//  rpgGame
//
//  Created by Mitchell Lam on 2/17/21.
//

import SpriteKit

class Enemy {
    var gameScene: GameScene
    
    //textures
    var enemy: SKSpriteNode?
    var target: Player?
    var healthBar: SKSpriteNode?
    var healthBarWidth: CGFloat?
    
    //stats
    var name: String?
    var radius: CGFloat?
    var moveSpeed: CGFloat?
    var maxHealth: CGFloat?
    var health: CGFloat?
    var attackRange: CGFloat?
    var attackStagger: Double? // the time length to stagger player
    var attackHitFrame: Double? // the time that attack actual hits
    var attackDamage: CGFloat?
    var attackSpeed: CGFloat?
    var projectileName: String?
    var projectileSpeed: CGFloat?
    var projectileLifeTime: Double?
    var aggroRange: CGFloat?
    var aggroed: Bool = false
    var score: Int?
    
    //animations
    var startTime = NSDate()
    var cooldown: Double = 0.0
    var elapsedTime: Double = 0.0
    var currentAnimation = Animation.idle
    enum Animation {
        case idle
        case walk
        case run
        case hit
        case attack1
        case attack2
        case death
    }
    
    init(gameScene:GameScene, enemy: SKSpriteNode, target: Player) {
        self.gameScene = gameScene
        self.enemy = enemy
        self.target = target
        self.healthBar = SKSpriteNode(imageNamed: "Health")
        enemy.addChild(healthBar!)
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
        if(currentAnimation != .walk){
            enemy!.removeAllActions()
            if(moveSpeed! <= 100){
                enemy!.run(SKAction(named: name! + "_walk")!)
            } else if (moveSpeed! > 100) {
                enemy!.run(SKAction(named: name! + "_run")!)
                
            }
            currentAnimation = .walk
        }
    }
    
    func MeleeAttack() {
        //stats
        startTime = NSDate()
        cooldown = attackHitFrame! * 3.0
        
        //animations
        currentAnimation = .attack1
        enemy!.removeAllActions()
        enemy!.run(SKAction(named: name! + "_attack1")!)
        enemy!.physicsBody?.pinned = true
        
        //hit check
        DispatchQueue.main.asyncAfter(deadline: .now() + attackHitFrame!) { [self] in
            if(TargetDistance() <= attackRange! && currentAnimation == .attack1 && target?.currentAction != .death){
                target?.hit(damage: attackDamage!, staggerTimer: attackStagger!)
            }
        }
    }
    
    func RangeAttack() {
        //move once to relocate the direction
        Move()
        
        //stats
        let projectile = SKSpriteNode(imageNamed: projectileName!)
        projectile.name = projectileName
        startTime = NSDate()
        cooldown = attackHitFrame! * 3.0
        
        //animations
        currentAnimation = .attack1
        enemy!.removeAllActions()
        enemy!.run(SKAction(named: name! + "_attack1")!)
        enemy!.physicsBody?.pinned = true
        
        // delay functions
        // shot projectile fits animation time
        DispatchQueue.main.asyncAfter(deadline: .now() + attackHitFrame!) { [self] in
            if currentAnimation == .attack1 {
                
                //calculations
                let angle = TargetAngle()
                let newVelocity = CGVector(dx: projectileSpeed! * cos(angle), dy: projectileSpeed! * sin(angle))
                
                // physics
                projectile.position = enemy!.position
                projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/10)
                projectile.anchorPoint = CGPoint(x: 0.1, y: 0.5)
                projectile.physicsBody?.isDynamic = true
                projectile.physicsBody?.allowsRotation = false
                projectile.physicsBody?.usesPreciseCollisionDetection = true
                projectile.physicsBody?.categoryBitMask = bitMask.projectile
                projectile.physicsBody?.collisionBitMask = bitMask.none
                projectile.physicsBody?.contactTestBitMask = bitMask.player | bitMask.wall
                
                let rotationAction = SKAction.rotate(toAngle: angle + .pi, duration: 0)
                projectile.run(rotationAction)
                let scaleAction = SKAction.scale(to: CGFloat(2), duration: 0)
                projectile.run(scaleAction)
                projectile.physicsBody!.velocity = newVelocity
                
                //display
                gameScene.addChild(projectile)
                projectile.run(SKAction(named: projectileName!)!)
                
                //remove projectile after life time
                DispatchQueue.main.asyncAfter(deadline: .now() + projectileLifeTime!) {
                    projectile.removeFromParent()
                }
            }
        }
    }
    
    
    func hit(damage: CGFloat) {
        //stats
        self.health! -= damage
        startTime = NSDate()
        if cooldown < 1.0 {
            cooldown = 1.0
        }
        
        // if death
        if(health! <= 0) {
            Death()
            return
        }
        
        // animation
        enemy!.removeAllActions()
        enemy!.run(SKAction(named: name! + "_hit")!)
        currentAnimation = .hit
        
        // pinned and release after cooldown
        enemy!.physicsBody?.pinned = true
    }
    
    func Death() {
        //animation and physics
        if(currentAnimation != .death){
            enemy!.zPosition = -1
            enemy!.removeAllActions()
            enemy!.physicsBody?.isResting = true
            enemy!.run(SKAction(named: name! + "_death")!)
        }
        //status
        health = 0
        currentAnimation = .death
        UserInterface()
        
        //score
        target?.maxScore += self.score!
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
        //UI
        UserInterface()
        
        //dead
        if(health! <= 0) {
            return
        }
        
        // movements
        if(elapsedTime > cooldown) {
            enemy?.physicsBody?.pinned = false
            if TargetDistance() <= attackRange! {
                if(attackRange! >= 100){
                    RangeAttack()
                } else {
                    MeleeAttack()
                }
            } else if !(enemy!.hasActions()) {
                Idle()
            } else if(aggroed){
                Move()
            }
        }
        
        //aggro if play in range
        if(TargetDistance() <= aggroRange! && !aggroed){
            setAggroState(state: true)
        }
        
        // animation cooldown timer
        elapsedTime = startTime.timeIntervalSinceNow * -1
    }
    
    func setAggroState(state: Bool) {
        aggroed = state
    }
}
