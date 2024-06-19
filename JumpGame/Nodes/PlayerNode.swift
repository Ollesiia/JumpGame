//
//  PlayerNode.swift
//  JumpGame
//
//  Created by Олеся Скидан on 13.05.2024.
//

import Foundation
import SpriteKit


class PlayerNode: SKNode {
    private var player: SKShapeNode!
    private var diff = 0
    private let radius: CGFloat = 30.0
    
    init(diff: Int) {
        super.init()
        self.diff = diff
        self.name = "Player"
        self.zPosition = 10.0
        self.setupPhysics()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension PlayerNode {
    
    private func setupPhysics() {
        player = SKShapeNode(circleOfRadius: radius)
        player.name = "Player"
        player.zPosition = .pi
        player.fillColor = UIColor(hex: 0xFF43FC)
        player.physicsBody = SKPhysicsBody(circleOfRadius: radius*0.8)
        player.physicsBody?.isDynamic = false
        player.physicsBody?.linearDamping = 0.0
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.affectedByGravity = true
        player.physicsBody?.usesPreciseCollisionDetection = true
        player.physicsBody?.restitution = 0.0
        player.physicsBody?.friction = 1.0
        player.physicsBody?.mass = 10.0
        player.physicsBody?.categoryBitMask = PhysicsCategories.Player
        player.physicsBody?.contactTestBitMask = PhysicsCategories.Wall | PhysicsCategories.Side | PhysicsCategories.Obstacles | PhysicsCategories.Score | PhysicsCategories.SuperScore
        player.physicsBody?.collisionBitMask = PhysicsCategories.Side
        addChild(player)
    }
    
    internal func activate(_ isDynamic: Bool) {
        player.physicsBody?.isDynamic = isDynamic
    }
    
    internal func jump(_ right: Bool) {
        let velocity = CGVector(dx: right ? -200 : 200, dy: 1000.0)
        player.physicsBody?.velocity = velocity
    }
    
    internal func over() {
        player.fillColor = .red
        activate(false)
    }
    
    internal func side() {
        player.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 50.0))
    }
    
    internal func height () -> CGFloat {
        return player.position.y + screerHeight/2 * 0.75
    }
    
}

