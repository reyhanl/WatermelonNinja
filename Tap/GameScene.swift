//
//  GameScene.swift
//  Tap
//
//  Created by reyhan muhammad on 03/12/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private lazy var scoreLabel : SKLabelNode = {
        let label = SKLabelNode(text: "0")
        let rangeToLeftBorder = SKRange(lowerLimit: 10.0, upperLimit: 150.0)
        let distanceConstraint = SKConstraint.distance(rangeToLeftBorder, to: label)
        label.constraints = [distanceConstraint]
        label.position = .init(x: -width / 2 + label.frame.size.width + 10, y: height / 2 - 100)
        return label
    }()
    lazy var firstHealth: Heart = {
       let node = Heart()
        node.isEmpty = false
        node.setSize(width: width / 12)
        return node
    }()
    lazy var secondHealth: Heart = {
       let node = Heart()
        node.isEmpty = false
        node.setSize(width: width / 12)
        return node
    }()
    lazy var thirdHealth: Heart = {
       let node = Heart()
        node.isEmpty = false
        node.setSize(width: width / 12)
        return node
    }()
    
    lazy var retryButton: SKSpriteNode = {
       let node = SKSpriteNode()
        node.texture = .init(imageNamed: "retry")
        node.size = .init(width: width / 5, height: width / 5)
        node.name = "retry"
        return node
    }()
    
    
    private var spinnyNode : SKShapeNode?
    var isGameOver: Bool = false
    var initialTouchPosition: CGPoint?
    
    var slicedFruits: [SKNode] = []
    var shouldBeSlicedFruit: [SKNode] = []
    
    lazy var width: CGFloat = {
        let width = self.frame.width
        return width
    }()
    lazy var height: CGFloat = {
        let height = self.frame.height
        return height
    }()
    lazy var nodeSize: CGFloat = {
        let width = self.frame.width
        return width / 3
    }()
    var score = 0{
        didSet{
            scoreLabel.text = "\(score)"
        }
    }
    var health = 3{
        didSet{
            if health == 3{
                firstHealth.isEmpty = false
                secondHealth.isEmpty = false
                thirdHealth.isEmpty = false
            }else if health == 2{
                executeHealth(node: thirdHealth)
            }else if health == 1{
                executeHealth(node: secondHealth)
                executeHealth(node: secondHealth)
            }else if health == 0{
                executeHealth(node: thirdHealth)
                executeHealth(node: secondHealth)
                executeHealth(node: firstHealth)
                gameOver()
            }
        }
    }
    var generateFruitTimer: Timer?
    
    override func didMove(to view: SKView) {
        addChild(scoreLabel)
        startGame()
    }
    
    func startGame(){
        score = 0
        health = 3
        isGameOver = false
        generateFruitTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.generateFruit()
        }
        addHeartNodes()
    }
    
    func addDummyWatermelon(){
        let node = Fruit()
        node.size = .init(width: width / 3, height: width / 3)
        node.name = "fruit"
        node.position = .zero
        addChild(node)
    }
    
    func generateFruit(){
        for i in 0...Int.random(in: 0...2){
            let type = Int.random(in: 0...3)
            var node: SKNode = SKNode()
            let x = CGFloat.random(in: -width / 2...width / 2)
            if type == 0{
                node = makeBomb(at: .init(x: x, y: -height / 2))
            }else{
                node = makeWatermelon(at: .init(x: x, y: -height / 2))
            }
            addChild(node)
            animateFruit(node: node)
        }
    }
    
    func makeWatermelon(at: CGPoint? = nil) -> SKNode{
        

        let node = Fruit()
        node.size = .init(width: nodeSize, height: nodeSize)
        node.position = .zero
        node.name = "fruit"
        
        let body = makeBody()
        node.physicsBody = body
                
        node.position = at ?? .zero
        return node
    }
    
    func makeBomb(at: CGPoint? = nil) -> SKNode{
        

        let node = Bomb()
        node.size = .init(width: nodeSize, height: nodeSize)
        
        let body = makeBody()
        node.physicsBody = body
                
        node.position = at ?? .zero
        return node
    }
    
    func sliceFruit(node: SKNode){
        guard !slicedFruits.contains(node) else{return}
        slicedFruits.append(node)
        
        animateSliceFruit(node: node)
        
        score += 1
        
        node.removeFromParent()
    }
    
    func animateSliceFruit(node: SKNode){
        let rotation = node.zRotation

        let leftSlice = SKSpriteNode(imageNamed: "sliceLeft")
        leftSlice.size = .init(width: nodeSize, height: nodeSize)
        leftSlice.position = node.position
        leftSlice.zPosition = 0
        leftSlice.physicsBody = makeBody()
        leftSlice.physicsBody?.velocity.dx = -nodeSize / 2
        leftSlice.zRotation = rotation
        addChild(leftSlice)
        
        let rightSlice = SKSpriteNode(imageNamed: "sliceRight")
        rightSlice.size = .init(width: nodeSize, height: nodeSize)
        rightSlice.position = node.position
        rightSlice.physicsBody = makeBody()
        rightSlice.zPosition = 1
        rightSlice.physicsBody?.velocity.dx = nodeSize / 2
        rightSlice.zRotation = rotation
        addChild(rightSlice)
        
    }
    
    func addRetryButton(){
        addChild(retryButton)
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
    
    func addHeartNodes(){
        let safeAreaY = (height / 2) - 100
        let padding: CGFloat = 10
        
        guard firstHealth.parent == nil else{return}
        firstHealth.position = .init(x: width / 2 - firstHealth.size.width, y: safeAreaY)
        firstHealth.isEmpty = false
        addChild(firstHealth)
        
        secondHealth.position = firstHealth.position
        secondHealth.isEmpty = false
        secondHealth.position.x -= firstHealth.frame.size.width + padding
        addChild(secondHealth)

        thirdHealth.position = secondHealth.position
        thirdHealth.isEmpty = false
        thirdHealth.position.x -= secondHealth.frame.size.width + padding
        addChild(thirdHealth)
    }
    
    func animateFruit(node: SKNode){
        let height = self.frame.height
        let width = self.frame.width

        guard let body = node.physicsBody else{return}
        let moveX = CGFloat.random(in: -width / 2...width / 2)
        body.velocity = .init(dx: moveX, dy: height + height / 2)
    }
    
    func gameOver(){
        generateFruitTimer?.invalidate()
        for child in children.filter({$0 is Fruit}){
            animateSliceFruit(node: child)
        }
        addRetryButton()
    }
    
    func executeHealth(node: SKNode){
        guard let node = node as? Heart, !node.isEmpty else{return}
        node.isEmpty = true
        let leftSlice = SKSpriteNode(imageNamed: "heart.sliceLeft")
        leftSlice.size = node.frame.size
        leftSlice.position = node.position
        leftSlice.zPosition = 0
        leftSlice.physicsBody = makeBody()
        leftSlice.physicsBody?.velocity.dx = -nodeSize / 2
        addChild(leftSlice)
        
        let rightSlice = SKSpriteNode(imageNamed: "heart.sliceRight")
        rightSlice.size = node.frame.size
        rightSlice.position = node.position
        rightSlice.physicsBody = makeBody()
        rightSlice.zPosition = 1
        rightSlice.physicsBody?.velocity.dx = nodeSize / 2
        addChild(rightSlice)
        
        node.isEmpty = true
    }
    
    func touchDown(atPoint pos : CGPoint) {
        initialTouchPosition = pos
        for node in nodes(at: pos){
            if node.name == "retry"{
                retryButton.removeFromParent()
                startGame()
            }
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if nodes(at: pos).count > 0{
            for node in nodes(at: pos){
                if node is Fruit{
                    sliceFruit(node: node)
                }else if node is Bomb{
                    guard isGameOver == false else{return}
                    isGameOver = true
                    self.generateFruitTimer?.invalidate()
                    node.run(.scale(by: 2, duration: 0.2)) {
                        node.run(.scale(by: 0.5, duration: 0.2)) { [weak self] in
                            self?.health = 0
                        }
                    }
                }
            }
        }
    }
    
    override func didSimulatePhysics() {
        super.didSimulatePhysics()
        let bottom = -(height / 2)
        for node in children{
            if let node = node as? Fruit{
                if node.position.y > bottom{
                    node.isOnScreen = true
                }else if node.isOnScreen && node.position.y < bottom{
                    node.removeFromParent()
                    guard health != 0 else{return}
                    health -= 1
                }
            }else{
                if node.position.y < bottom{
                    node.removeFromParent()
                }
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
