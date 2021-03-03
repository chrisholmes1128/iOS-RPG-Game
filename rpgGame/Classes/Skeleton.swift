//
//  Skeleton.swift
//  rpgGame
//
//  Created by Mitchell Lam on 2/17/21.
//

import SpriteKit

class Skeleton: Enemy {
    
    override init(enemy: SKSpriteNode, target: Player) {
        super.init(enemy: enemy, target: target)
        name = "skeleton"
        maxHealth = 100
        health = maxHealth
        moveSpeed = 75
        attackRange = 70
        attackHitFrame = 1.0
        attackDamage = 10
    }
}
