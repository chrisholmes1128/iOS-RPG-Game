//
//  Bat.swift
//  rpgGame
//
//  Created by Mitchell Lam on 3/3/21.
//

import SpriteKit

class Bat: Enemy {
    
    override init(gameScene:SKScene, enemy: SKSpriteNode, target: Player) {
        super.init(gameScene:gameScene, enemy: enemy, target: target)
        //stats
        name = "bat"
        radius = 50
        maxHealth = 50
        health = maxHealth
        moveSpeed = 200
        attackRange = 30
        attackStagger = 0.1
        attackHitFrame = 0.6
        attackDamage = 5
        aggroRange = 400
        
        //health bar
        healthBar?.size.height = 4
        healthBar?.size.width = enemy.size.width / 4
        healthBar?.position.y = enemy.size.height / 6
        self.healthBarWidth = self.healthBar?.size.width
        
        //physics
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: enemy.size.width/4)
        enemy.physicsBody?.isDynamic = true
        enemy.physicsBody?.allowsRotation = false
        enemy.physicsBody?.restitution = 0
        enemy.physicsBody?.collisionBitMask = bitMask.wall
        enemy.physicsBody?.categoryBitMask = bitMask.enemy
    }
}
