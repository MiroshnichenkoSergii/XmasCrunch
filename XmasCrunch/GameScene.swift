//
//  GameScene.swift
//  XmasCrunch
//
//  Created by Sergii Miroshnichenko on 09.12.2022.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
      super.init(size: size)
      
      anchorPoint = CGPoint(x: 0.5, y: 0.5)
      
      let background = SKSpriteNode(imageNamed: "background")
      background.size = size
      addChild(background)
      
    }
}
