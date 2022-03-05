//
//  CatSprite.swift
//  RainCat
//
//  Created by sun on 2022/03/05.
//

import SpriteKit

import Then

public class CatSprite: SKSpriteNode {
    public static func newInstance() -> CatSprite {
        CatSprite(imageNamed: "cat_one").then{
            $0.zPosition = 3
            /// makes the car roll around when hit by raindrops or the umbrella
            $0.physicsBody = SKPhysicsBody(circleOfRadius: $0.size.width / 2)
            $0.physicsBody?.categoryBitMask = CatCategory
            $0.physicsBody?.contactTestBitMask = RainDropCategory | WorldFrameCategory
        }
    }
    
    public func update(deltaTime: TimeInterval) {
        
    }
}
