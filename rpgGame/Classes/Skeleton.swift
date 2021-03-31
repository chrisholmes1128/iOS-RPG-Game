//
//  Skeleton.swift
//  rpgGame
//
//  Created by Mitchell Lam on 2/17/21.
//

import SpriteKit

class Skeleton: Enemy {
    
    override init(gameScene:GameScene, enemy: SKSpriteNode, target: Player) {
        super.init(gameScene:gameScene, enemy: enemy, target: target)
        name = "skeleton"
        radius = 100
        maxHealth = 100
        health = maxHealth
        moveSpeed = 50
        attackRange = 70
        attackStagger = 0.5
        attackHitFrame = 1.0
        attackDamage = 20
        aggroRange = 400
        score = 300
        
        //health bar
        healthBar?.size.height = 3
        healthBar?.size.width = enemy.size.width / 3
        healthBar?.position.y = enemy.size.height / 7
        self.healthBarWidth = self.healthBar?.size.width
        
        //physics
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: enemy.size.width / 1.5)
        enemy.physicsBody?.isDynamic = true
        enemy.physicsBody?.allowsRotation = false
        enemy.physicsBody?.restitution = 0
        enemy.physicsBody?.categoryBitMask = bitMask.enemy
        enemy.physicsBody?.collisionBitMask = bitMask.wall
        enemy.physicsBody?.contactTestBitMask = bitMask.none
    }
}
