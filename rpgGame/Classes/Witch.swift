//
//  Witch.swift
//  rpgGame
//
//  Created by Mitchell Lam on 3/3/21.
//

import SpriteKit

class Witch: Enemy {
    
    override init(gameScene:SKScene, enemy: SKSpriteNode, target: Player) {
        super.init(gameScene:gameScene, enemy: enemy, target: target)
        //stats
        name = "witch"
        radius = 100
        maxHealth = 100
        health = maxHealth
        moveSpeed = 50
        attackRange = 500
        attackStagger = 0.3
        attackDamage = 15
        attackHitFrame = 1.3
        aggroRange = 800
        score = 500
        projectileName = "fireball_black_000"
        projectileSpeed = 200
        projectileLifeTime = 5.0
        
        //health bar
        healthBar?.size.height = 3
        healthBar?.size.width = enemy.size.width / 4
        healthBar?.position.y = enemy.size.height / 7
        self.healthBarWidth = self.healthBar?.size.width
        
        //physics
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: enemy.size.width / 3)
        enemy.physicsBody?.isDynamic = true
        enemy.physicsBody?.allowsRotation = false
        enemy.physicsBody?.restitution = 0
        enemy.physicsBody?.collisionBitMask = bitMask.wall
        enemy.physicsBody?.categoryBitMask = bitMask.enemy
    }
}
