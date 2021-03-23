//
//  Skeleton.swift
//  rpgGame
//
//  Created by Mitchell Lam on 2/17/21.
//

import SpriteKit

class Skeleton: Enemy {
    
    override init(gameScene:SKScene, enemy: SKSpriteNode, target: Player) {
        super.init(gameScene:gameScene, enemy: enemy, target: target)
        name = "skeleton"
        radius = 100
        maxHealth = 100
        health = maxHealth
        moveSpeed = 50
        attackRange = 70
        attackStagger = 0.5
        attackHitFrame = 1.0
        attackDamage = 30
        aggroRange = 300
    }
}
