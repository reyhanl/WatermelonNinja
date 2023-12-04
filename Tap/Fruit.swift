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

class Heart: SKSpriteNode{
    var isEmpty: Bool = false{
        didSet{
            texture = isEmpty ? .init(imageNamed: "heart"):.init(imageNamed: "heart.fill")
        }
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setSize(width: CGFloat){
        if let image = UIImage(named: "heart") {
            let tempWidth = width
            let tempHeight = tempWidth / image.size.width * image.size.height
            let size = CGSize(width: tempWidth, height: tempHeight)
            self.size = size
        }
    }
}

