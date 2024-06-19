//
//  StartScene.swift
//  JumpGame
//
//  Created by Олеся Скидан on 14.05.2024.
//

import SpriteKit
import GameplayKit

class StartScene: SKScene {

    private var bgNode: SKSpriteNode!
    private var titleLabel: SKLabelNode!
    private var easyButton: SKSpriteNode!
    private var mediumButton: SKSpriteNode!
    private var hardButton: SKSpriteNode!
    private var mediumLock: SKSpriteNode!
    private var hardLock: SKSpriteNode!

    var skView: SKView!

    override func didMove(to view: SKView) {
        setupNodes()
    }

    private func setupNodes() {
        addBG()
        addTitle()
        addButtons()
    }

    private func addBG() {
        bgNode = SKSpriteNode(imageNamed: "background")
        bgNode.zPosition = -1.0
        bgNode.position = CGPoint(x: frame.midX, y: frame.midY)
        bgNode.size = self.size
        addChild(bgNode)
    }

    private func addTitle() {
        titleLabel = SKLabelNode(text: "icon-jump")
        titleLabel.fontSize = 40
        titleLabel.fontColor = .white
        titleLabel.position = CGPoint(x: frame.midX, y: frame.height * 0.8)
        addChild(titleLabel)
    }

    private func addButtons() {
        let buttonSpacing: CGFloat = 20.0

        // Easy button
        easyButton = SKSpriteNode(imageNamed: "icon-ease")
        easyButton.name = "easyButton"
        easyButton.position = CGPoint(x: frame.midX, y: frame.midY + easyButton.size.height + buttonSpacing)
        easyButton.zPosition = 1.0
        addChild(easyButton)

        // Medium button
        mediumButton = SKSpriteNode(imageNamed: "icon-medium")
        mediumButton.name = "mediumButton"
        mediumButton.position = CGPoint(x: frame.midX, y: frame.midY)
        mediumButton.zPosition = 1.0
        addChild(mediumButton)

        // Hard button
        hardButton = SKSpriteNode(imageNamed: "icon-hard")
        hardButton.name = "hardButton"
        hardButton.position = CGPoint(x: frame.midX, y: frame.midY - hardButton.size.height - buttonSpacing)
        hardButton.zPosition = 1.0
        addChild(hardButton)

        // Locks
        if !UserDefaults.standard.bool(forKey: "EasyLevelCompleted") {
            mediumLock = SKSpriteNode(imageNamed: "icon-lock")
            mediumLock.zPosition = 2.0
            mediumLock.position = mediumButton.position
            addChild(mediumLock)
            mediumButton.isUserInteractionEnabled = false
        }

        if !UserDefaults.standard.bool(forKey: "MediumLevelCompleted") {
            hardLock = SKSpriteNode(imageNamed: "icon-lock")
            hardLock.zPosition = 2.0
            hardLock.position = hardButton.position
            addChild(hardLock)
            hardButton.isUserInteractionEnabled = false
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let node = atPoint(location)
        
        if node.name == "easyButton" {
            let scene = EasyScene(size: self.size)
            scene.scaleMode = .aspectFill
            self.view?.presentScene(scene, transition: .doorway(withDuration: 1.5))
            
        } else if node.name == "mediumButton" && UserDefaults.standard.bool(forKey: "EasyLevelCompleted") {
            let scene = MediumScene(size: self.size)
            scene.scaleMode = .aspectFill
            self.view?.presentScene(scene, transition: .doorway(withDuration: 1.5))
            
        } else if node.name == "hardButton" && UserDefaults.standard.bool(forKey: "MediumLevelCompleted") {
            let scene = HardScene(size: self.size)
            scene.scaleMode = .aspectFill
            self.view?.presentScene(scene, transition: .doorway(withDuration: 1.5))
        }
    }
}
