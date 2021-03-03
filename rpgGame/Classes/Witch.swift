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
        name = "witch"
        radius = 70
        maxHealth = 400
        health = maxHealth
        moveSpeed = 50
        attackRange = 500
        attackStagger = 0.3
        attackHitFrame = 1.2
        attackDamage = 15
        projectile = SKSpriteNode(imageNamed: "fireball_black_000")

    }
}
