//
//  GameScene.swift
//  RainCat
//
//  Created by sun on 2022/03/04.
//

import GameplayKit
import SpriteKit

import Then

class GameScene: SKScene {

    private var lastUpdateTime: TimeInterval = 0
    private var currentRainDropSpawnTime: TimeInterval = 0
    private var rainDropSpawnRate: TimeInterval = 0.5
    private let random = GKARC4RandomSource()
    
    private let umbrella = UmbrellaSprite.newInstance()

    override func sceneDidLoad() {
        
        self.lastUpdateTime = 0
        
        let worldFrame = self.frame.with {
            $0.origin.x -= 100
            $0.origin.y -= 100
            $0.size.height += 200
            $0.size.width += 200
        }
        /// created to remove node(e.g. raindrops) that bounce off screen
        /// we need to manually remove the node from the parent
        /// and  also clear the physics body to prevent the scene holding onto it to update during the render cycle
        /// using this init creates an empty rectangle that allows collisions only at the edges of the frame
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: worldFrame)
        self.physicsWorld.contactDelegate = self
        self.physicsBody?.categoryBitMask = WorldFrameCategory
        
        let floorNode = SKShapeNode(rectOf: CGSize(width: self.size.width, height: 5)).then {
            $0.position = CGPoint(x: self.size.width / 2, y: 50)
            $0.fillColor = SKColor.systemYellow
            /// add an edge-based body to keep it fixed in postition instead of being effected by gravity
            $0.physicsBody = SKPhysicsBody(
                edgeFrom: CGPoint(x: -self.size.width / 2, y: 0),
                to: CGPoint(x: self.size.width, y: 0)
            )
            $0.physicsBody?.categoryBitMask = FloorCategory
            $0.physicsBody?.contactTestBitMask = RainDropCategory
            $0.physicsBody?.restitution = 0.3
        }
        self.addChild(floorNode)
        
        self.umbrella.updatePosition(point: CGPoint(x: self.frame.midX, y: self.frame.midY))
        self.addChild(umbrella)
//
//        for _ in 0...5 {
//            spawnRainDrop()
//        }
    }
    
    /// spawns rain drops at random positions
    private func spawnRainDrop() {
        let rainDrop = SKShapeNode(rectOf: CGSize(width: 20, height: 20)).then {
            $0.fillColor = .systemBlue
            /// add volumen based physics body to enable drop downs caused by gravity
            $0.physicsBody = SKPhysicsBody(rectangleOf: CGSize(
                width: $0.frame.width,
                height: $0.frame.height
            ))
            let randomPosition = abs(CGFloat(random.nextInt()).truncatingRemainder(dividingBy: self.size.width))
            $0.position = CGPoint(x: randomPosition, y: self.size.height)
            $0.physicsBody?.categoryBitMask = RainDropCategory
            $0.physicsBody?.contactTestBitMask = WorldFrameCategory
        }
        self.addChild(rainDrop)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self)
        else { return }
        
        self.umbrella.setDestination(destination: point)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self)
        else { return }
        
        self.umbrella.setDestination(destination: point)
    }

    override func update(_ currentTime: TimeInterval) {
//        print("scene update")
        // Called before each frame is rendered

        // Initialize _lastUpdateTime if it has not already been
        if self.lastUpdateTime == 0 {
            self.lastUpdateTime = currentTime
        }

        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime

        self.lastUpdateTime = currentTime
        
        /// Update the Spawn Timer
        self.currentRainDropSpawnTime += dt
        
        if self.currentRainDropSpawnTime > self.rainDropSpawnRate {
            self.currentRainDropSpawnTime = 0
            spawnRainDrop()
        }
        
        self.umbrella.update(deltaTime: dt)
    }
}


// MARK: - SKPhysicsContactDelegate

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        /// removes the collision bit mask of the raindrop to block further collision
        if contact.bodyA.categoryBitMask == RainDropCategory {
            contact.bodyA.node?.physicsBody?.collisionBitMask = 0
        } else if contact.bodyB.categoryBitMask == RainDropCategory {
            contact.bodyB.node?.physicsBody?.collisionBitMask = 0
        }
        
        /// cull the nodes
        if contact.bodyA.categoryBitMask == WorldFrameCategory {
            contact.bodyB.node?.removeFromParent()
            contact.bodyB.node?.physicsBody = nil
            contact.bodyB.node?.removeAllActions()
        } else if contact.bodyB.categoryBitMask == WorldFrameCategory {
            contact.bodyA.node?.removeFromParent()
            contact.bodyA.node?.physicsBody = nil
            contact.bodyA.node?.removeAllActions()
        }
    }
}
