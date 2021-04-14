//
//  Skeleton.swift
//  rpgGame
//
//  Created by Mitchell Lam on 2/17/21.
//

import SpriteKit

class Golem: Enemy {
    
    override init(gameScene:GameScene, enemy: SKSpriteNode, target: Player) {
        super.init(gameScene:gameScene, enemy: enemy, target: target)
        name = "golem"
        radius = 100
        maxHealth = 300
        health = maxHealth
        moveSpeed = 30
        attackRange = 100
        attackStagger = 0.5
        attackHitFrame = 1.4
        attackDamage = 30
        aggroRange = 300
        score = 700
        
        //health bar
        healthBar?.size.height = 1
        healthBar?.size.width = enemy.size.width / 18
        healthBar?.position.y = enemy.size.height / 30
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
        target?.SpeechBubble(text: "Big = Slow")
        
        //win condidtion for level 2
        if gameScene.name == "Level2" {
            let golems: [SKNode] = gameScene["golem"]
            var deadGolems = 0
            for golem in golems {
                if ((golem.physicsBody?.isResting) != nil) {
                    deadGolems += 1
                }
            }
            print(deadGolems)
            if deadGolems >= 2 {
                target?.SpeechBubble(text: "I heard something from the entry...")
                let tileSet = SKTileSet(named: "dungeon_tools")
                gameScene.objects?.setTileGroup(tileSet?.tileGroups[6], forColumn: 29, row: 29)
            }
            
        }
    }
}
