//
//  Fruit.swift
//  Tap
//
//  Created by reyhan muhammad on 03/12/23.
//

import SpriteKit

class Fruit: SKSpriteNode{
    var isOnScreen = false
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        self.texture = .init(imageNamed: "watermelon")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.texture = .init(imageNamed: "watermelon")
    }
}
