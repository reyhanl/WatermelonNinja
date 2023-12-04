//
//  Bomb.swift
//  Tap
//
//  Created by reyhan muhammad on 04/12/23.
//

import SpriteKit

class Bomb: SKSpriteNode{
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        self.texture = .init(imageNamed: "bomb")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.texture = .init(imageNamed: "bomb")
    }
}
