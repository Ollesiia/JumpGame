//
//  GameViewController.swift
//  JumpGame
//
//  Created by Олеся Скидан on 13.05.2024.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let view = self.view as? SKView else {
            return
        }
        let scene = StartScene(size: CGSize(width: screenWidth, height: screerHeight))
        scene.scaleMode = .aspectFill
        
        view.ignoresSiblingOrder = true
        view.showsFPS = true
        view.showsNodeCount = true
        view.showsPhysics = false
        view.presentScene (scene)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
