//
//  GameScene.swift
//  Tap
//
//  Created by reyhan muhammad on 03/12/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    var initialTouchPosition: CGPoint?
    
    var slicedFruits: [SKNode] = []
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.generateFruit()
        }
    }
    
    func generateFruit(){
        let height = self.frame.height
        let width = self.frame.width

        for i in 0...Int.random(in: 0...3){
            let x = CGFloat.random(in: -width / 2...width / 2)
            let node = makeWatermelon(at: .init(x: x, y: -height / 2))
            addChild(node)
            animateFruit(node: node)
        }
    }
    
    func makeWatermelon(at: CGPoint? = nil) -> SKNode{
        let height = self.frame.height
        let width = self.frame.width

        let node = SKSpriteNode(imageNamed: "watermelon")
        node.size = .init(width: width / 3, height: width / 3)
        node.position = .zero
        node.name = "fruit"
        
        let body = makeBody()
        node.physicsBody = body
                
        node.position = at ?? .zero
        return node
    }
    
    func sliceFruit(node: SKNode){
        guard !slicedFruits.contains(node) else{return}
        let height = self.frame.height
        let width = self.frame.width
        
        slicedFruits.append(node)

        let leftSlice = SKSpriteNode(imageNamed: "sliceLeft")
        leftSlice.size = .init(width: width / 3, height: width / 3)
        leftSlice.position = node.position
        leftSlice.zPosition = 0
        leftSlice.physicsBody = makeBody()
        leftSlice.physicsBody?.velocity.dx = -width / 6
        addChild(leftSlice)
        
        let rightSlice = SKSpriteNode(imageNamed: "sliceRight")
        rightSlice.size = .init(width: width / 3, height: width / 3)
        rightSlice.position = node.position
        rightSlice.physicsBody = makeBody()
        rightSlice.zPosition = 1
        rightSlice.physicsBody?.velocity.dx = width / 6
        addChild(rightSlice)
        
        node.removeFromParent()
    }
    
    func makeBody() -> SKPhysicsBody{
        let body = SKPhysicsBody()
        body.affectedByGravity = true
        body.angularDamping = 0.2
        body.charge = 0.2
        body.allowsRotation = true
        body.mass = 0.2
        body.angularVelocity = .random(in: -1...1)
                
        return body
    }
    
    func animateFruit(node: SKNode){
        let height = self.frame.height
        let width = self.frame.width

        guard let body = node.physicsBody else{return}
        let moveX = CGFloat.random(in: -width / 2...width / 2)
        body.velocity = .init(dx: moveX, dy: height + height / 2)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        initialTouchPosition = pos
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if nodes(at: pos).count > 0{
            if let node = nodes(at: pos).first(where: {$0.name == "fruit"}){
                sliceFruit(node: node)
            }
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
