//
//  Skeleton.swift
//  rpgGame
//
//  Created by Mitchell Lam on 2/17/21.
//

import SpriteKit

class Enemy {
    var enemy: SKSpriteNode?
    var target: Player?
    var name: String?
    
    var moveSpeed: CGFloat?
    var maxHealth: CGFloat?
    var health: CGFloat?
    var attackRange: CGFloat?
    var attackHitFrame: Double? // the time that attack actual hits
    var attackDamage: CGFloat?
    
    var startTime = NSDate()
    var cooldown: Double = 0.0
    var elapsedTime: Double = 0.0
    var newAction = Action.idle
    var currentAction = Action.hit
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
        
        //velocity
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
        newAction = .walk
    }
    
    func Attack() {
        if(elapsedTime > cooldown) {
            startTime = NSDate()
            newAction = .attack1
            cooldown = 3.0
            DispatchQueue.main.asyncAfter(deadline: .now() + attackHitFrame!) { [self] in
                if(TargetDistance() <= attackRange! && currentAction == .attack1){
                    target?.hit(damage: attackDamage!)
                }
            }
        }
    }
    
    func Update(target: CGPoint) {
        //movements
        if(elapsedTime > cooldown) {
            if TargetDistance() <= attackRange! {
                enemy!.physicsBody!.pinned = true
                Attack()
            } else {
                enemy!.physicsBody!.pinned = false
                Move()
            }
        }
        // animation
        elapsedTime = startTime.timeIntervalSinceNow * -1
        
        //idle if stop moving
        if(newAction != .walk && elapsedTime > cooldown){
            newAction = .idle
        }
        
        //execute
        if newAction != currentAction{
            switch newAction {
            case .idle:
                enemy!.run(SKAction(named: name! + "_idle")!)
            case .walk:
                enemy!.run(SKAction(named: name! + "_walk")!)
            case .run:
                enemy!.run(SKAction(named: name! + "_run")!)
            case .hit:
                enemy!.run(SKAction(named: name! + "_hit")!)
            case .attack1:
                enemy!.run(SKAction(named: name! + "_attack1")!)
            case .attack2:
                enemy!.run(SKAction(named: name! + "_attack2")!)
            case .death:
                enemy!.run(SKAction(named: name! + "_death")!)
            }
            currentAction = newAction
        }
    }
    
}
