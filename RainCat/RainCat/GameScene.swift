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
    /// reusable reference to the raindrop texture
    /// adding an image atlas for further optimization
    private let rainDropTexture = SKTexture(imageNamed: "rain_drop")
    
    private var cat: CatSprite!
    
    /// acts as a margin to prevent the food being spawned near the edges
    private let foodEdgeMargin: CGFloat = 75.0
    
    /// required to point the cat in the right direction
    private var food: FoodSprite!

    override func sceneDidLoad() {
        
        self.lastUpdateTime = 0
        
        configureWorldFrame()
        configureFloorNode()
        configureUmbrella()
        configureBackground()
        spawnCat()
        spawnFood()
//        for _ in 0...5 {
//            spawnRainDrop()
//        }
    }
    
    /// spawns rain drops at random positions
    private func spawnRainDrop() {
        let rainDrop = SKSpriteNode(texture: rainDropTexture).then {
            /// add volume-based physics body to enable drop downs caused by gravity
            $0.physicsBody = SKPhysicsBody(rectangleOf: CGSize(
                width: $0.frame.width,
                height: $0.frame.height
            ))
            /// physics body that outline the texutre, abondoned for asethetic reasons
//            $0.physicsBody = SKPhysicsBody(texture: rainDropTexture, size: $0.size)
            
            let randomPosition = abs(CGFloat(random.nextInt())
                                        .truncatingRemainder(dividingBy: self.size.width))
            $0.position = CGPoint(x: randomPosition, y: self.size.height)
            $0.physicsBody?.categoryBitMask = RainDropCategory
            $0.physicsBody?.contactTestBitMask = WorldFrameCategory
            $0.physicsBody?.density = 0.5
            $0.zPosition = 2
        }
        self.addChild(rainDrop)
    }
    
    /// spawns the cat, implemented as a separate method for reuse
    private func spawnCat() {
        if let currentCat = self.cat, self.children.contains(currentCat) {
            currentCat.removeFromParent()
            currentCat.removeAllActions()
            currentCat.physicsBody = nil
        }
        
        self.cat = CatSprite.newInstance().then {
            $0.position = CGPoint(x: self.umbrella.position.x, y: self.umbrella.position.y)
        }
        
        self.addChild(self.cat)
    }
    
    private func spawnFood() {
        if let currentFood = food, self.children.contains(food) {
            currentFood.removeFromParent()
            currentFood.removeAllActions()
            currentFood.physicsBody = nil
        }
        
        var randomPosition = CGFloat(self.random.nextInt())
        randomPosition = randomPosition.truncatingRemainder(dividingBy: self.size.width - foodEdgeMargin * 2)
        randomPosition = CGFloat(abs(randomPosition))
        randomPosition += foodEdgeMargin
        
        self.food = FoodSprite.newInstance().then {
            $0.position = CGPoint(x: randomPosition, y: self.size.height)
        }
        self.addChild(food)
    }
    
    private func configureFloorNode() {
        let floorNode = SKShapeNode(rectOf: CGSize(width: self.size.width, height: 5)).then {
            $0.position = CGPoint(x: self.size.width / 2, y: 50)
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
    }
    
    private func configureUmbrella() {
        self.umbrella.updatePosition(point: CGPoint(x: self.frame.midX, y: self.frame.midY))
        self.umbrella.zPosition = 1
        self.addChild(umbrella)
    }
    
    /// created to remove node(e.g. raindrops) that bounce off screen
    /// we need to manually remove the node from the parent
    /// and  also clear the physics body to prevent the scene holding onto it to update during the render cycle
    private func configureWorldFrame() {
        let worldFrame = self.frame.with {
            $0.origin.x -= 100
            $0.origin.y -= 100
            $0.size.height += 200
            $0.size.width += 200
        }
        /// using this init creates an empty rectangle that allows collisions only at the edges of the frame
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: worldFrame)
        self.physicsWorld.contactDelegate = self
        self.physicsBody?.categoryBitMask = WorldFrameCategory
    }
    
    private func configureBackground() {
        let background = SKSpriteNode(imageNamed: "background").then {
            $0.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            $0.zPosition = 0
            $0.size = CGSize(width: frame.width, height: frame.height)
        }
        self.addChild(background)
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
        self.cat.update(deltaTime: dt, foodLocation: self.food.position)
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

        if contact.bodyA.categoryBitMask == FoodCategory || contact.bodyB.categoryBitMask == FoodCategory {
            self.handleFoodHit(contact: contact)
            
            return
        }
        
        if contact.bodyA.categoryBitMask == CatCategory || contact.bodyB.categoryBitMask == CatCategory {
            self.handleCatCollision(contact: contact)
            
            return
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
    
    /// look for a physics body that is not the cat
    fileprivate func handleCatCollision(contact: SKPhysicsContact) {
        var otherBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask == CatCategory {
            otherBody = contact.bodyB
        } else {
            otherBody = contact.bodyA
        }
        
        switch otherBody.categoryBitMask {
        case RainDropCategory:
            self.cat.hitByRain()
        case WorldFrameCategory:
            spawnCat()
        default:
            print("Something hit the cat")
        }
    }
    
    private func handleFoodHit(contact: SKPhysicsContact) {
        var otherBody: SKPhysicsBody
        var foodBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask == FoodCategory {
            otherBody = contact.bodyB
            foodBody = contact.bodyA
        } else {
            otherBody = contact.bodyA
            foodBody = contact.bodyB
        }
        
        switch otherBody.categoryBitMask {
        case CatCategory:
            // TODO: incre,ent points
            print("fed cat")
            fallthrough
        case WorldFrameCategory:
            foodBody.node?.removeFromParent()
            foodBody.node?.physicsBody = nil
            
            spawnFood()
        default:
            print("sth else touched the food")
        }
    }
}
