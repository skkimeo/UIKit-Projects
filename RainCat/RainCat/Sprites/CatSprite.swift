//
//  CatSprite.swift
//  RainCat
//
//  Created by sun on 2022/03/05.
//

import SpriteKit

import Then

public class CatSprite: SKSpriteNode {
    
    /// key used to add a walking actions
    /// enables stopping the walking action w/o removing all of the actions
    private let walkingActionKey = "action_walking"
    
    /// key used to detect the rotated state of the cat
    private let rotationActionKey = "action_rotate"
    
    /// contains the texture that we'll switch b/w while the cat is walking
    private let walkFrames = [
        SKTexture(imageNamed: "cat_one"),
        SKTexture(imageNamed: "cat_two")
    ]

    /// the cat's moving speed
    private let movementSpeed: CGFloat = 100
    
    /// time interval since the cat was last hit
    private var timeSinceLastHit: TimeInterval = 2
    
    /// how long the cat will be stunned
    /// set equal to timeSinceLastHit to prevent the cat being stunned when spawned
    private var maxFlailtime: TimeInterval = 2
    
    public static func newInstance() -> CatSprite {
        CatSprite(imageNamed: "cat_one").then{
            $0.zPosition = 3
            /// makes the car roll around when hit by raindrops or the umbrella
            $0.physicsBody = SKPhysicsBody(circleOfRadius: $0.size.width / 2)
            $0.physicsBody?.categoryBitMask = CatCategory
            $0.physicsBody?.contactTestBitMask = RainDropCategory | WorldFrameCategory
        }
    }
    
    /// moves the cat toward the food
    public func update(deltaTime: TimeInterval, foodLocation: CGPoint) {
        
        self.timeSinceLastHit += deltaTime
        
        /// if the cat has been hit and stun is still in effect return right away
        guard self.timeSinceLastHit >= self.maxFlailtime
        else { return }
        
        if self.zRotation != 0 && action(forKey: self.rotationActionKey) == nil {
            run(SKAction.rotate(toAngle: 0, duration: 0.25), withKey: self.rotationActionKey)
        }
        
        /// if the walking animations hasn't been created, create and adds the walking animation.
        if action(forKey: self.walkingActionKey) == nil {
            let walkingAction = SKAction.repeatForever(SKAction.animate(
                with: self.walkFrames,
                timePerFrame: 0.1,
                resize: false,
                restore: false
            ))
            run(walkingAction, withKey: walkingActionKey)
        }
        
        /// make the cat stand still if the food is right above
        if foodLocation.y > self.position.y && abs(foodLocation.x - self.position.x) < 2 {
            /// update velocity to prevent slowing down
            self.physicsBody?.velocity.dx = 0
            self.removeAction(forKey: walkingActionKey)
            texture = walkFrames[1]
        } else if foodLocation.x < position.x {
            /// food on the left
            /// nudges the cat towards the current direction to make it appear as if it's moving
            /// e.g. if the deltaTime is 0.166 and the movementSpeed is 100, the cat is moved 16.6pt left
            self.position.x -= self.movementSpeed * CGFloat(deltaTime)
            /// flips the cat to make the cat face the correct direction
            self.xScale = -1
        } else {
            /// food on the right
            self.position.x += self.movementSpeed * CGFloat(deltaTime)
            self.xScale = 1
        }
        /// reset angular velocity to prevent the cat from becoming jittery
        self.physicsBody?.angularVelocity = 0
    }
    
    /// stops the cat when hit by rain
    public func hitByRain() {
        self.timeSinceLastHit = 0
        removeAction(forKey: self.walkingActionKey)
    }
}
