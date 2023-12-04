//
//  Heart.swift
//  Tap
//
//  Created by reyhan muhammad on 04/12/23.
//

import SpriteKit

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

