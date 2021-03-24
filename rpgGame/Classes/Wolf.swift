//
//  Wolf.swift
//  rpgGame
//
//  Created by Mitchell Lam on 3/3/21.
//

import SpriteKit

class Wolf: Enemy {
    
    override init(gameScene:SKScene, enemy: SKSpriteNode, target: Player) {
        super.init(gameScene:gameScene, enemy: enemy, target: target)
        name = "wolf"
        radius = 50
        maxHealth = 50
        health = maxHealth
        moveSpeed = 200
        attackRange = 30
        attackStagger = 0.1
        attackHitFrame = 0.6
        attackDamage = 5
        aggroRange = 800
    }
    
    override func setAggroState(state: Bool) {
        super.setAggroState(state: state)
        let sfx = SKAction.playSoundFileNamed("wolf_aggroed.mp3", waitForCompletion: false)
        enemy!.run(sfx)
    }
}
