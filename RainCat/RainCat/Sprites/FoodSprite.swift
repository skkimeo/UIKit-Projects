//
//  FoodSprite.swift
//  RainCat
//
//  Created by sun on 2022/03/05.
//

import SpriteKit

import Then

public class FoodSprite: SKSpriteNode {
    public static func newInstance() -> FoodSprite {
        FoodSprite(imageNamed: "food_dish").then {
            $0.physicsBody = SKPhysicsBody(rectangleOf: $0.size)
            $0.physicsBody?.categoryBitMask = FoodCategory
            $0.physicsBody?.contactTestBitMask = WorldFrameCategory | RainDropCategory | CatCategory
            $0.zPosition = 3
        }
    }
}
