//
//  Types.swift
//  JumpGame
//
//  Created by Олеся Скидан on 13.05.2024.
//

import UIKit

let screenWidth: CGFloat = 1536.0
let screerHeight: CGFloat = 2048.0

let appDL = UIApplication.shared.delegate as! AppDelegate
var playableRect: CGRect {
    var ratio: CGFloat = 16/9
    if appDL.isIPhoneX {
        ratio = 2.16
    } else if appDL.isIPad11 {
        ratio = 1.43
    }
    let w: CGFloat = screerHeight / ratio
    let h: CGFloat = screerHeight
    let x: CGFloat = (screenWidth - w) / 2
    let y: CGFloat = 0.0
    
    return CGRect(x: x, y: y, width: w, height: h)
}

struct PhysicsCategories {
    static let Player:     UInt32 = 0b1
    static let Wall:       UInt32 = 0b10
    static let Side:       UInt32 = 0b100
    static let Obstacles:  UInt32 = 0b1000
    static let Score:      UInt32 = 0b10000
    static let SuperScore: UInt32 = 0b100000
    static let SmallBlock: UInt32 = 0x1000000
}

struct FontName {
    static let rimouski = "Rimouski"
    static let wheaton = "Wheaton"
}

