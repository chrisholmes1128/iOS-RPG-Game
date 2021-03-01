//
//  Skeleton.swift
//  rpgGame
//
//  Created by Mitchell Lam on 2/17/21.
//

import SpriteKit

class Enemy {
    var enemy: SKSpriteNode?
    var name: String?
    
    var moveSpeed: CGFloat?
    
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
    
    init(enemy: SKSpriteNode, name: String, moveSpeed: CGFloat) {
        self.enemy = enemy
        self.name = name
        self.moveSpeed = moveSpeed
    }
    
    func Move(target: CGPoint) -> CGFloat{
        //calculations
        let angle = atan2(target.y - (enemy?.position.y)!, target.x - (enemy?.position.x)!)
        let distance = sqrt(pow(target.x - (enemy?.position.x)!, 2) + pow(target.y - (enemy?.position.y)!, 2))
        
        //velocity
        let newVelocity = CGVector(dx: moveSpeed! * cos(angle), dy: moveSpeed! * sin(angle))
        enemy!.physicsBody!.velocity = newVelocity
        
        //direction
        let direction:CGFloat
        if(target.x < (enemy?.position.x)!) {
            direction = -1.0
        } else {
            direction = 1.0
        }
        enemy?.xScale = abs(enemy!.xScale) * direction
        
        return distance
    }
    
    func Attack() {
        if(elapsedTime > cooldown) {
            startTime = NSDate()
            newAction = .attack1
            cooldown = 3.0
        }
    }
    
    func Update(target: CGPoint) {
        //movements
        if(elapsedTime > cooldown) {
            if Move(target: target) <= 30 {
                enemy!.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
                Attack()
            }
        }
        // animation
        elapsedTime = startTime.timeIntervalSinceNow * -1
        if(elapsedTime>cooldown){
            newAction = .idle
        }
        
        // move if velocity > 0
        let normal = sqrt(pow((enemy!.physicsBody?.velocity.dx)!, 2) + pow((enemy!.physicsBody?.velocity.dy)!, 2))
        if(normal > 0){
            newAction = .walk
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
        
        //idle if stop moving
        if(currentAction == .walk && normal == 0){
            newAction = .idle
        }
    }
    
}
