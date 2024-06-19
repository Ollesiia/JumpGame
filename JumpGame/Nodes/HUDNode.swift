//
//  HUDNode.swift
//  JumpGame
//
//  Created by Олеся Скидан on 13.05.2024.
//

import Foundation
import SpriteKit

class HUDNode: SKNode {
    private var topScoreShape: SKShapeNode!
    private var topScoreLbl: SKLabelNode!
    
    private var gameOverShape: SKShapeNode!
    private var gameOverNode: SKSpriteNode!
    
    private var homeNode: SKSpriteNode!
    private var againNode: SKSpriteNode!
    
    private var scoreTitleLbl: SKLabelNode!
    private var scoreLbl: SKLabelNode!
    private var highscoreTitleLbl: SKLabelNode!
    private var highscoreLbl: SKLabelNode!
    
    var easeScene: EasyScene?
    var mediumScene: MediumScene?
    var hardScene: HardScene?
    var skView: SKView!
    
    private var nextNode: SKSpriteNode!
    
    private var panelNode: SKSpriteNode!
    private var panelTitleLbl: SKLabelNode!
    private var panelSubLbl: SKLabelNode!
    
    private var isHome = false {
        didSet {
            updateBtn(node: homeNode, event: isHome)
        }
    }
        
    private var isAgain = false {
        didSet {
            updateBtn(node: againNode, event: isAgain)
        }
    }
    
    private var isNext = false {
        didSet {
            updateBtn(node: nextNode, event: isNext)
        }
    }
    
    private var isPanel = false {
        didSet {
            updateBtn(node: panelNode, event: isPanel)
        }
    }
    
    override init() {
        super.init()
        setupTopScore()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        let node = atPoint(touch.location(in: self))
        if node.name == "Home" && !isHome {
            isHome = true
        }
        if node.name == "PlayAgain" && !isAgain {
            isAgain = true
        }
        
        if node.name == "Next" && !isNext {
            isNext = true
        }
        
        if node.name == "Panel" && !isPanel {
            isPanel = true
        }

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if isHome {
            isHome = false
            let scene = StartScene(size: CGSize(width: screenWidth, height: screerHeight))
            scene.scaleMode = .aspectFill
            skView.presentScene(scene, transition: .doorway(withDuration: 1.5))
        }
        
        if isAgain {
            isAgain = false
            if let _ = easeScene {
                let scene = EasyScene(size: CGSize(width: screenWidth, height: screerHeight))
                scene.scaleMode = .aspectFill
                skView.presentScene(scene, transition: .doorway(withDuration: 1.5))
            }
            
            if let _ = mediumScene {
                let scene = MediumScene(size: CGSize(width: screenWidth, height: screerHeight))
                scene.scaleMode = .aspectFill
                skView.presentScene(scene, transition: .doorway(withDuration: 1.5))
            }
            
            if let _ = hardScene {
                let scene = HardScene(size: CGSize(width: screenWidth, height: screerHeight))
                scene.scaleMode = .aspectFill
                skView.presentScene(scene, transition: .doorway(withDuration: 1.5))
            }
        }
        
        if isNext {
            isNext = false
            if let _ = easeScene {
                let scene = MediumScene(size: CGSize(width: screenWidth, height: screerHeight))
                scene.scaleMode = .aspectFill
                skView.presentScene(scene, transition: .doorway(withDuration: 1.5))
                UserDefaults.standard.set(true, forKey: "EasyLevelCompleted")
            } else if let _ = mediumScene {
                let scene = HardScene(size: CGSize(width: screenWidth, height: screerHeight))
                scene.scaleMode = .aspectFill
                skView.presentScene(scene, transition: .doorway(withDuration: 1.5))
                UserDefaults.standard.set(true, forKey: "MediumLevelCompleted")
            } else if let _ = hardScene {
                let scene = StartScene(size: CGSize(width: screenWidth, height: screerHeight))
                scene.scaleMode = .aspectFill
                skView.presentScene(scene, transition: .doorway(withDuration: 1.5))
            }
        }
        
        if isPanel {
            isPanel = false
            removeNode()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first else { return }
        
        if let parent = homeNode?.parent {
            isHome = homeNode.contains(touch.location(in: parent))
        }
        if let parent = againNode?.parent {
            isAgain = againNode.contains(touch.location(in: parent))
        }
        
        if let parent = nextNode?.parent {
            isNext = nextNode.contains(touch.location(in: parent))
        }
        
        if let parent = panelNode?.parent {
            isPanel = panelNode.contains(touch.location(in: parent))
        }
    }
}

extension HUDNode {
    
    private func updateBtn(node: SKNode?, event: Bool) {
        guard let node = node else {
            return
        }
        var alpha: CGFloat = 1.0
        if event {
            alpha = 0.5
        }
        node.run(.fadeAlpha(to: alpha, duration: 0.1))
    }
    
    private func setupTopScore() {
        let statusH: CGFloat = appDL.isIPhoneX ? 88 : 40
        let scoreY: CGFloat = screerHeight - (statusH + 90 / 2 + 20)
        topScoreShape = SKShapeNode(rectOf: CGSize(width: 220, height: 90), cornerRadius: 8.0)
        topScoreShape.fillColor = UIColor(hex: 0x000000, alpha: 0.5)
        topScoreShape.zPosition = 20.0
        topScoreShape.position = CGPoint(x: screenWidth / 2, y: scoreY)
        
        addChild(topScoreShape)
        topScoreLbl = SKLabelNode(fontNamed: FontName.wheaton)
        topScoreLbl.fontSize = 60.0
        topScoreLbl.text = "0"
        topScoreLbl.zPosition = 25.0
        topScoreLbl.fontColor = .white
        topScoreLbl.position = CGPoint(x: topScoreShape.frame.midX, y: topScoreShape.frame.midY - topScoreLbl.frame.height / 2)
        addChild(topScoreLbl)
    }
    
    func updateScore(_ score: Int) {
        topScoreLbl.text = "\(score)"
        topScoreLbl.run(.sequence([
            .scale(to: 1.3, duration: 0.1),
            .scale(to: 1.0, duration: 0.1),
        ]))
    }
    
    func removeNode() {
        gameOverShape?.removeFromParent()
        gameOverNode?.removeFromParent()
        nextNode?.removeFromParent()
        panelNode?.removeFromParent()
        panelSubLbl?.removeFromParent()
        panelTitleLbl?.removeFromParent()
    }
}

extension HUDNode {
    
    private func createGameOverShape() {
        gameOverShape = SKShapeNode(rect: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: screerHeight))
        gameOverShape.zPosition = 49.0
        gameOverShape.fillColor = UIColor(hex: 0x000000, alpha: 0.7)
        addChild(gameOverShape)
    }
    
    private func createGamePanel(_ name: String) {
        let scale: CGFloat = appDL.isIPhoneX ? 0.6 : 0.7
        gameOverNode = SKSpriteNode(imageNamed: name)
        gameOverNode.setScale(scale)
        gameOverNode.zPosition = 50.0
        gameOverNode.position = CGPoint(x: screenWidth / 2, y: screerHeight / 2)
        addChild(gameOverNode)
    }
        
    func setupGameOver(_ score: Int, _ heightScore: Int) {
        createGameOverShape()
        
        isUserInteractionEnabled = true
        
        let scale: CGFloat = appDL.isIPhoneX ? 0.6 : 0.7
        
        createGamePanel("panel-gameOver")
        
        homeNode = SKSpriteNode(imageNamed: "icon-home")
        homeNode.setScale(scale)
        homeNode.zPosition = 55.0
        homeNode.position = CGPoint(
            x: gameOverNode.frame.minX + homeNode.frame.width / 2 + 30,
            y: gameOverNode.frame.minY + homeNode.frame.height / 2 + 30)
        homeNode.name = "Home"
        addChild(homeNode)
        
        againNode = SKSpriteNode(imageNamed: "icon-playAgain")
        againNode.setScale(scale)
        againNode.zPosition = 55.0
        againNode.position = CGPoint(
            x: gameOverNode.frame.maxX - homeNode.frame.width / 2 - 30,
            y: gameOverNode.frame.minY + homeNode.frame.height / 2 + 30)
        againNode.name = "PlayAgain"
        addChild(againNode)
        
        scoreTitleLbl = SKLabelNode(fontNamed: FontName.wheaton)
        scoreTitleLbl.fontSize = 60.0
        scoreTitleLbl.text = "Score:"
        scoreTitleLbl.fontColor = .white
        scoreTitleLbl.zPosition = 55.0
        scoreTitleLbl.position = CGPoint(
            x: gameOverNode.frame.minX + scoreTitleLbl.frame.width / 2 + 30,
            y: screerHeight / 2)
        addChild(scoreTitleLbl)
        
        scoreLbl = SKLabelNode(fontNamed: FontName.wheaton)
        scoreLbl.fontSize = 60.0
        scoreLbl.text = "\(score)"
        scoreLbl.fontColor = .white
        scoreLbl.zPosition = 55.0
        scoreLbl.position = CGPoint(
            x: gameOverNode.frame.maxX - scoreLbl.frame.width / 2 - 30,
            y: scoreTitleLbl.position.y)
        addChild(scoreLbl)
        
        highscoreTitleLbl = SKLabelNode(fontNamed: FontName.wheaton)
        highscoreTitleLbl.fontSize = 60.0
        highscoreTitleLbl.text = "Highscore:"
        highscoreTitleLbl.fontColor = .white
        highscoreTitleLbl.zPosition = 55.0
        highscoreTitleLbl.position = CGPoint(
            x: gameOverNode.frame.minX + highscoreTitleLbl.frame.width / 2 + 30,
            y: screerHeight / 2 - highscoreTitleLbl.frame.height * 2)
        addChild(highscoreTitleLbl)
        
        highscoreLbl = SKLabelNode(fontNamed: FontName.wheaton)
        highscoreLbl.fontSize = 60.0
        highscoreLbl.text = "\(heightScore)"
        highscoreLbl.fontColor = .white
        highscoreLbl.zPosition = 55.0
        highscoreLbl.position = CGPoint(
            x: gameOverNode.frame.maxX - highscoreLbl.frame.width / 2 - 30,
            y: highscoreTitleLbl.position.y)
        addChild(highscoreLbl)
    }
}

extension HUDNode {
    func setupSuccess() {
        createGameOverShape()
        
        isUserInteractionEnabled = true
        
        let scale: CGFloat = appDL.isIPhoneX ? 0.6 : 0.7
        
        createGamePanel("panel-success")

        if let _ = easeScene {
            nextNode = SKSpriteNode(imageNamed: "icon-next")
            nextNode.name = "Next"
        } else if let _ = mediumScene {
            nextNode = SKSpriteNode(imageNamed: "icon-next")
            nextNode.name = "Next"
        } else if let _ = hardScene {
            nextNode = SKSpriteNode(imageNamed: "icon-home")
            nextNode.name = "Home"
        }
        
        nextNode.setScale(scale)
        nextNode.zPosition = 55.0
        nextNode.position = CGPoint(
            x: gameOverNode.frame.midX,
            y: gameOverNode.frame.minY + nextNode.frame.height / 2 + 30)
        addChild(nextNode)
    }
}

extension HUDNode {
    func setupPanel(subTxt: String, titleTxt: String, btnName: String) {
        createGameOverShape()
        isUserInteractionEnabled = true
        let scale: CGFloat = appDL.isIPhoneX ? 0.6 : 0.7
        
        createGamePanel("panel")
        
        panelNode = SKSpriteNode(imageNamed: "icon-next")
        panelNode.setScale(scale)
        panelNode.zPosition = 55.0
        panelNode.position = CGPoint(
            x: gameOverNode.frame.midX,
            y: gameOverNode.frame.minY + panelNode.frame.height / 2 + 30)
        panelNode.name = "Panel"
        addChild(panelNode)
        
        panelTitleLbl = SKLabelNode(fontNamed: FontName.rimouski)
        panelTitleLbl.fontSize = 50.0
        panelTitleLbl.text = titleTxt
        panelTitleLbl.fontColor = .white
        panelTitleLbl.zPosition = 55.0
        panelTitleLbl.preferredMaxLayoutWidth = gameOverNode.frame.width - 60
        panelTitleLbl.numberOfLines = 0
        panelTitleLbl.position = CGPoint(
            x: gameOverNode.frame.midX,
            y: gameOverNode.frame.maxY - panelTitleLbl.frame.height - 20)
        addChild(panelTitleLbl)
        
        panelSubLbl = SKLabelNode(fontNamed: FontName.rimouski)
        panelSubLbl.fontSize = 30.0
        panelSubLbl.text = subTxt
        panelSubLbl.fontColor = .white
        panelSubLbl.zPosition = 55.0
        panelSubLbl.preferredMaxLayoutWidth = gameOverNode.frame.width * 0.7
        panelSubLbl.numberOfLines = 0
        panelSubLbl.position = CGPoint(
            x: gameOverNode.frame.midX,
            y: gameOverNode.frame.midY - panelSubLbl.frame.height / 2 + 30)
        addChild(panelSubLbl)
    }
}
