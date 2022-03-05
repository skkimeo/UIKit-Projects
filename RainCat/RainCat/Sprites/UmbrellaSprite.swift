//
//  UmbrellaSprite.swift
//  RainCat
//
//  Created by sun on 2022/03/05.
//

import Foundation
import SpriteKit

import Then

public class UmbrellaSprite: SKSpriteNode {
    
    private var destination: CGPoint!
    private var easing: CGFloat = 0.1
    
    public static func newInstance() -> UmbrellaSprite {
        let umbrella = UmbrellaSprite(imageNamed: "umbrella")
        
        let path = UIBezierPath().then {
            /// anchor point is (0.5, 0.5) so .zero is the center point of the sprite
            $0.move(to: .zero)
            /// extended the edges by 30 pt to secure more room to block raindrops while maintaining the look of the sprite...
            $0.addLine(to: CGPoint(x: -umbrella.size.width / 2 - 30, y: 0))
            $0.addLine(to: CGPoint(x: 0, y: umbrella.size.height / 2))
            $0.addLine(to: CGPoint(x: umbrella.size.width / 2 + 30, y: 0))
        }
        /// completes the path above when added to the body
        umbrella.physicsBody = SKPhysicsBody(polygonFrom: path.cgPath)
        /// physics must not be dynamic to block gravity
        umbrella.physicsBody?.isDynamic = false
        /// tells the umbrella sprite its category
        umbrella.physicsBody?.categoryBitMask = UmbrellaCategory
        /// informs that it only cares contact with the RainDropCategory
        umbrella.physicsBody?.contactTestBitMask = RainDropCategory
        umbrella.physicsBody?.restitution = 0.9

        return umbrella
    }
    
    /// updates initial position
    public func updatePosition(point: CGPoint) {
        self.position = point
        self.destination = point
    }
    
    /// sets the destination that the position will move towards to
    public func setDestination(destination: CGPoint) {
        self.destination = destination
    }
    
    /// updates the sprite's position until it reaches destination by moving towards it gradually
    public func update(deltaTime: TimeInterval) {
        let distance = sqrt(
            pow(self.destination.x - self.position.x, 2) +
            pow(self.destination.y - self.position.y, 2)
        )
        
        /// this phase(if clause) is repeated until the remaining distance is smaller than 1,
        /// where the sprite is then positioned to the destination right away by the else clause
        if distance > 1 {
            let directionX = self.destination.x - self.position.x
            let directionY = self.destination.y - self.position.y
            
            position.x += directionX * easing
            position.y += directionY * easing
        } else {
            self.position = destination
        }
    }
}
