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
        projectileName = "fireball_black_000"
        projectileSpeed = 200
        projectileLifeTime = 5.0
        
        //physics
        
    }
}
