//
//  SideNode.swift
//  JumpGame
//
//  Created by Олеся Скидан on 13.05.2024.
//

import SpriteKit


class SideNode: SKNode {
    
    private var node: SKSpriteNode!
    
    override init() {
        super.init()
        self.name = "Side"
        self.zPosition = 5.0
        self.setupPhysics ()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension SideNode {
    private func setupPhysics() {
        let size = CGSize(width: 40.0, height: screerHeight)
        node = SKSpriteNode(color: .clear, size: size)
        node.physicsBody = SKPhysicsBody(rectangleOf: size)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.friction = 1.0
        node.physicsBody?.restitution = 0.0
        node.physicsBody?.categoryBitMask = PhysicsCategories.Side
        addChild(node)
    }
}

