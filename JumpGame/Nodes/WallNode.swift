//
//  WallNode.swift
//  JumpGame
//
//  Created by Олеся Скидан on 13.05.2024.
//

import Foundation
import SpriteKit


class WallNode: SKNode {
    private var node: SKSpriteNode!
    
    override init() {
        super.init()
        self.name = "Wall"
        self.zPosition = 5.0
        self.setupPhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension WallNode {
    
    private func setupPhysics () {
        let size = CGSize(width: screenWidth, height: 40.0)
        node = SKSpriteNode (color: .clear, size: size)
        node.physicsBody = SKPhysicsBody(rectangleOf: size)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.mass = 100.0
        node.physicsBody?.restitution = 1.0
        node.physicsBody?.categoryBitMask = PhysicsCategories.Wall
        node.physicsBody?.collisionBitMask = PhysicsCategories.Player
        addChild (node)
    }
    
}


