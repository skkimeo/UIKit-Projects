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

    override func sceneDidLoad() {
        self.lastUpdateTime = 0

        let floorNode = SKShapeNode(rectOf: CGSize(width: self.size.width, height: 5)).then {
            $0.position = CGPoint(x: self.size.width / 2, y: 50)
            $0.fillColor = SKColor.systemYellow
            /// add an edge-based body to keep it fixed in postition instead of being effected by gravity
            $0.physicsBody = SKPhysicsBody(
                edgeFrom: CGPoint(x: -self.size.width, y: 0),
                to: CGPoint(x: self.size.width, y: 0)
            )
        }
        self.addChild(floorNode)
        
        for _ in 0...5 {
            spawnRainDrop()
        }
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
            $0.position = CGPoint(x: randomPosition, y: self.size.height / 3 * 2)
        }
        self.addChild(rainDrop)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }

    override func update(_ currentTime: TimeInterval) {
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
        
        if self.currentRainDropSpawnTime >= self.rainDropSpawnRate {
            self.currentRainDropSpawnTime = 0
            spawnRainDrop()
        }
    }
}
