//
//  MediumScenes.swift
//  JumpGame
//
//  Created by Олеся Скидан on 14.05.2024.
//

import SpriteKit
import GameplayKit


class MediumScene: SKScene {
    
    private let worldNode = SKNode()
    private var bgNode: SKSpriteNode!
    private let hudNode = HUDNode()
    
    private let playerNode = PlayerNode(diff: 0)
    private let wallNode = WallNode()
    private let sideNode = SideNode()
    var firstTap = true
    
    private let leftNode = SideNode()
    private let rightNode = SideNode()
    private let obstacleslNode = SKNode()
    
    lazy var colors: [ColorModel] = {
        return ColorModel.shared()
    }()
    
    private var posY: CGFloat = 0.0
    private var pairNum = 0
    private var score = 0
    
    private let notifKey = "MediumNotifKey"
    private let scoreKey = "MediumScoreKey"
    
    private let requestScore = 10
    
    private let btnName = "icon-go"
    private let titleTxt = "Wow!!! You are great"
    private let subTxt = """
    Continue 30 score to play next level.
    Trying!!!
"""
    
    override func didMove(to view: SKView) {
        setupNodes()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        if firstTap {
            playerNode.activate(true)
            firstTap = false
        }
        
        let location = touch.location(in: self)
        let right = !(location.x > frame.width / 2)
        playerNode.jump(right)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if -playerNode.height() + frame.midY < worldNode.position.y {
            worldNode.position.y = -playerNode.height() + frame.midY
        }
        if posY - playerNode.height() < frame.midY {
            addObstacles()
        }
        
        obstacleslNode.children.forEach({
            if $0.name == "Pair1" {
                $0.removeFromParent()
                print("removeFromParent")
            }
        })
    }
}

extension MediumScene {
    private func setupNodes() {
        backgroundColor = .red
        addBG()
        setupPhysics()
        addWall()
        addChild(hudNode)
        addChild(worldNode)
        
        hudNode.skView = view
        hudNode.mediumScene = self
        
        if !UserDefaults.standard.bool(forKey: scoreKey) {
            UserDefaults.standard.set(true, forKey: notifKey)
            hudNode.setupPanel(subTxt: subTxt, titleTxt: titleTxt, btnName: btnName)
        }
        
        playerNode.position = CGPoint(x: frame.midX, y: frame.midY * 0.6)
        worldNode.addChild(playerNode)
        
        worldNode.addChild(obstacleslNode)
        addObstacles()
        posY = frame.midY
    }
    
    private func setupPhysics() {
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -15.0)
        physicsWorld.contactDelegate = self
    }
}

extension MediumScene {
    private func addBG() {
        bgNode = SKSpriteNode(imageNamed: "background")
        bgNode.zPosition = -1.0
        bgNode.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(bgNode)
    }
}

extension MediumScene {
    private func addWall() {
        wallNode.position = CGPoint(x: frame.midX, y: 0.0)
        leftNode.position = CGPoint(x: playableRect.minX, y: frame.midY)
        rightNode.position = CGPoint(x: playableRect.maxX, y: frame.midY)
        
        addChild(wallNode)
        addChild(leftNode)
        addChild(rightNode)
    }
}

extension MediumScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let body = contact.bodyA.categoryBitMask == PhysicsCategories.Player ? contact.bodyB : contact.bodyA
        
        switch body.categoryBitMask {
        case PhysicsCategories.Wall:
            gameOver()
        case PhysicsCategories.Obstacles:
            gameOver()
            print("Obstacles")
        case PhysicsCategories.Score:
            if let node = body.node {
                score += 1
                hudNode.updateScore(score)
                
                let highscore = UserDefaults.standard.integer(forKey: scoreKey)
                if score > highscore {
                    UserDefaults.standard.set(score, forKey: scoreKey)
                }
                
                node.removeFromParent()
                success()
            }
        case PhysicsCategories.SuperScore:
            if let node = body.node {
                score += 5
                hudNode.updateScore(score)
                
                let highscore = UserDefaults.standard.integer(forKey: scoreKey)
                if score > highscore {
                    UserDefaults.standard.set(score, forKey: scoreKey)
                }
                
                node.removeFromParent()
                success()
            }
        default:
            break
        }
    }
}

extension MediumScene {
    private func gameOver() {
        playerNode.over()
        
        let highscore = UserDefaults.standard.integer(forKey: scoreKey)
        if score > highscore {
            UserDefaults.standard.set(score, forKey: scoreKey)
        }
        hudNode.setupGameOver(score, highscore)
    }
    
    private func success() {
        if score >= requestScore {
            playerNode.activate(false)
            hudNode.setupSuccess()
            UserDefaults.standard.set(true, forKey: "MediumLevelCompleted")
        }
    }
}

extension MediumScene {
    private func addObstacles() {
        let model = colors[Int(arc4random_uniform(UInt32(colors.count - 1)))]
        let model_1 = colors[Int(arc4random_uniform(UInt32(colors.count - 1)))]
        let randomX = CGFloat(arc4random() % UInt32(playableRect.width / 2))
        
        let pipePair = SKNode()
        pipePair.position = CGPoint(x: 0.0, y: posY)
        pipePair.zPosition = 1.0
        pipePair.name = "Pair"
        
        pairNum += 1
        pipePair.name = "Pair\(pairNum)"
        
        let size = CGSize(width: screenWidth, height: 50.0)
        let pipe1 = SKSpriteNode(color: model.color, size: size)
        pipe1.position = CGPoint(x: randomX - 270, y: 0.0)
        pipe1.physicsBody = SKPhysicsBody(rectangleOf: size)
        pipe1.physicsBody?.isDynamic = false
        pipe1.physicsBody?.categoryBitMask = PhysicsCategories.Obstacles
        
        let pipe2 = SKSpriteNode(color: model.color, size: size)
        pipe2.position = CGPoint(x: pipe1.position.x + size.width + 250, y: 0.0)
        pipe2.physicsBody = SKPhysicsBody(rectangleOf: size)
        pipe2.physicsBody?.isDynamic = false
        pipe2.physicsBody?.categoryBitMask = PhysicsCategories.Obstacles
        
        let blockSize = CGSize(width: 30.0, height: 30.0)
        if pipePair.name != "Pair1" {
            let random = CGFloat(arc4random() % 4)
            let block = SKSpriteNode(color: model_1.color, size: blockSize)
            block.position = CGPoint(
                x: pipe1.frame.maxX + ((random + 1) * 30),
                y: pipe1.position.y - 130)
            block.physicsBody = SKPhysicsBody(rectangleOf: blockSize)
            block.physicsBody?.isDynamic = false
            block.physicsBody?.categoryBitMask = PhysicsCategories.Obstacles
            pipePair.addChild(block)
        }
        
        let random = CGFloat(arc4random() % 4)
        let block = SKSpriteNode(color: model_1.color, size: blockSize)
        block.position = CGPoint(
            x: pipe1.frame.maxX + ((random + 1) * 30),
            y: pipe1.position.y + 130)
        block.physicsBody = SKPhysicsBody(rectangleOf: blockSize)
        block.physicsBody?.isDynamic = false
        block.physicsBody?.categoryBitMask = PhysicsCategories.Obstacles
        pipePair.addChild(block)
        
        let scoreNode = SKNode()
        scoreNode.position = CGPoint(x: 0.0, y: size.height)
        scoreNode.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: size.width * 2, height: size.height))
        scoreNode.physicsBody?.isDynamic = false
        scoreNode.physicsBody?.categoryBitMask = PhysicsCategories.Score
        
        pipePair.addChild(pipe1)
        pipePair.addChild(pipe2)
        pipePair.addChild(scoreNode)
        
        obstacleslNode.addChild(pipePair)
        
        switch arc4random_uniform(100) {
        case 0...80:
            break
        default:
            addSuperScore()
        }
        
        posY += frame.midY * 0.7
    }
    
    private func addSuperScore() {
        let node = SuperScoreNode()
        let randomX = playableRect.midX + CGFloat(arc4random_uniform(UInt32(playableRect.width / 2))) + node.frame.width
        let randomY = posY + CGFloat(arc4random_uniform(UInt32(posY * 0.5))) + node.frame.height
        node.position = CGPoint(x: randomX, y: randomY)
        worldNode.addChild(node)
        
        node.bounce()
    }
}
