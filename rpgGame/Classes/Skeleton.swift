//
//  Skeleton.swift
//  rpgGame
//
//  Created by Mitchell Lam on 2/17/21.
//

import SpriteKit

class Skeleton: Enemy {
    var attackMissSound: SKAction?
    
    override init(enemy: SKSpriteNode, target: Player) {
        super.init(enemy: enemy, target: target)
        name = "skeleton"
        maxHealth = 100
        moveSpeed = 75
        attackRange = 70
        attackHitFrame = 1.1
        attackDamage = 10
        attackMissSound = SKAction.playSoundFileNamed(name! + "_attack_miss.mp3", waitForCompletion: false)
    }
    
    override func Attack() {
        super .Attack()
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(attackHitFrame!)) { [self] in
            enemy!.run(attackMissSound!)
        }
    }
}
