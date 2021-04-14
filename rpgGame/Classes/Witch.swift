//
//  Witch.swift
//  rpgGame
//
//  Created by Mitchell Lam on 3/3/21.
//

import SpriteKit

class Witch: Enemy {
    
    override init(gameScene:GameScene, enemy: SKSpriteNode, target: Player) {
        super.init(gameScene:gameScene, enemy: enemy, target: target)
        //stats
        name = "witch"
        radius = 100
        maxHealth = 100
        health = maxHealth
        moveSpeed = 50
        attackRange = 500
        attackStagger = 0.3
        attackDamage = 5
        attackHitFrame = 0.65
        aggroRange = 500
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
        enemy.physicsBody?.categoryBitMask = bitMask.enemy
        enemy.physicsBody?.collisionBitMask = bitMask.wall
        enemy.physicsBody?.contactTestBitMask = bitMask.none
    }
    
    override func Death() {
        super.Death()
        target?.SpeechBubble(text: "Yikes.")
        
        // level 1 boss and win condition
        if gameScene.name == "Level1" {
            gameScene.currentGameState = .win
            gameScene.gameOver()
        }
    }
}
