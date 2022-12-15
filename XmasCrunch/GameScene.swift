//
//  GameScene.swift
//  XmasCrunch
//
//  Created by Sergii Miroshnichenko on 09.12.2022.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //MARK: - Properties
    var level: Level!
    
    let tilesLayer = SKNode()
    let cropLayer = SKCropNode()
    let maskLayer = SKNode()

    let tileWidth: CGFloat = 38.0
    let tileHeight: CGFloat = 38.0

    let gameLayer = SKNode()
    let itemsXLayer = SKNode()
    
    private var swipeFromColumn: Int?
    private var swipeFromRow: Int?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let texture = SKTexture(imageNamed: "background")
        let background = SKSpriteNode(texture: texture, glowRadius: 6.0, size: size)
        addChild(background)
        
        addChild(gameLayer)

        let layerPosition = CGPoint(
            x: -tileWidth * CGFloat(numColumns) / 2,
            y: -tileHeight * CGFloat(numRows) / 2)

        tilesLayer.position = layerPosition
        maskLayer.position = layerPosition
        cropLayer.maskNode = maskLayer
        gameLayer.addChild(tilesLayer)
        gameLayer.addChild(cropLayer)
        
        itemsXLayer.position = layerPosition
        cropLayer.addChild(itemsXLayer)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: itemsXLayer)
        let (success, column, row) = convertPoint(location)
        if success {
            if let itemX = level.itemX(atColumn: column, row: row) {
                swipeFromColumn = column
                swipeFromRow = row
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard swipeFromColumn != nil else { return }
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: itemsXLayer)
        
        let (success, column, row) = convertPoint(location)
        if success {
            var horizontalDelta = 0, verticalDelta = 0
            if column < swipeFromColumn! {          // swipe left
                horizontalDelta = -1
            } else if column > swipeFromColumn! {   // swipe right
                horizontalDelta = 1
            } else if row < swipeFromRow! {         // swipe down
                verticalDelta = -1
            } else if row > swipeFromRow! {         // swipe up
                verticalDelta = 1
            }
            
            if horizontalDelta != 0 || verticalDelta != 0 {
                trySwap(horizontalDelta: horizontalDelta, verticalDelta: verticalDelta)
                
                swipeFromColumn = nil
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        swipeFromColumn = nil
        swipeFromRow = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    
    //MARK: - Functions
    func addSprites(for itemsX: Set<ItemX>) {
        for itemX in itemsX {
            let sprite = SKSpriteNode(imageNamed: itemX.itemXType.spriteName)
            sprite.size = CGSize(width: tileWidth, height: tileHeight)
            sprite.position = pointFor(column: itemX.column, row: itemX.row)
            itemsXLayer.addChild(sprite)
            itemX.sprite = sprite
        }
    }
    
    private func pointFor(column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column) * tileWidth + tileWidth / 2,
            y: CGFloat(row) * tileHeight + tileHeight / 2)
    }
    
    private func convertPoint(_ point: CGPoint) -> (success: Bool, column: Int, row: Int) {
        if point.x >= 0 && point.x < CGFloat(numColumns) * tileWidth &&
            point.y >= 0 && point.y < CGFloat(numRows) * tileHeight {
            return (true, Int(point.x / tileWidth), Int(point.y / tileHeight))
        } else {
            return (false, 0, 0)  // invalid location
        }
    }
    
    private func trySwap(horizontalDelta: Int, verticalDelta: Int) {
        let toColumn = swipeFromColumn! + horizontalDelta
        let toRow = swipeFromRow! + verticalDelta
        
        guard toColumn >= 0 && toColumn < numColumns else { return }
        guard toRow >= 0 && toRow < numRows else { return }
        
        if let toItemX = level.itemX(atColumn: toColumn, row: toRow),
           let fromItemX = level.itemX(atColumn: swipeFromColumn!, row: swipeFromRow!) {
            print("*** swapping \(fromItemX) with \(toItemX)")
        }
    }

    func addTiles() {
        for row in 0..<numRows {
            for column in 0..<numColumns {
                if level.tileAt(column: column, row: row) != nil {
                    let tileNode = SKSpriteNode(imageNamed: "MaskTile")
                    tileNode.size = CGSize(width: tileWidth, height: tileHeight)
                    tileNode.position = pointFor(column: column, row: row)
                    maskLayer.addChild(tileNode)
                }
            }
        }
        
        for row in 0...numRows {
            for column in 0...numColumns {
                let topLeft     = (column > 0) && (row < numRows)
                && level.tileAt(column: column - 1, row: row) != nil
                
                let bottomLeft  = (column > 0) && (row > 0)
                && level.tileAt(column: column - 1, row: row - 1) != nil
                
                let topRight    = (column < numColumns) && (row < numRows)
                && level.tileAt(column: column, row: row) != nil
                
                let bottomRight = (column < numColumns) && (row > 0)
                && level.tileAt(column: column, row: row - 1) != nil
                
                let value = tile(with: (topLeft, topRight, bottomLeft, bottomRight))
                
                // Values 0 (no tiles) not drawn.
                if value != 0 {
                    let name = String(format: "Tile_%ld", value)
                    let tileNode = SKSpriteNode(imageNamed: name)
                    tileNode.size = CGSize(width: tileWidth, height: tileHeight)
                    var point = pointFor(column: column, row: row)
                    point.x -= tileWidth / 2
                    point.y -= tileHeight / 2
                    tileNode.position = point
                    tilesLayer.addChild(tileNode)
                }
            }
        }
    }

    private func tile(with config: (Bool, Bool, Bool, Bool)) -> Int {
        switch config {
            case (true, false, false, false):
                return 1
            case (false, true, false, false):
                return 2
            case (true, true, false, false):
                return 3
            case (false, false, true, false):
                return 4
            case (true, false, true, false):
                return 5
            case (true, true, true, false):
                return 7
            case (false, false, false, true):
                return 8
            case (false, true, false, true):
                return 10
            case (true, true, false, true):
                return 11
            case (false, false, true, true):
                return 12
            case (true, false, true, true):
                return 13
            case (false, true, true, true):
                return 14
            case (true, true, true, true):
                return 15
            default:
                return 0
        }
    }
}

//MARK: - Extensions
extension SKSpriteNode {
    /// Initializes a textured sprite with a glow using an existing texture object.
    convenience init(texture: SKTexture, glowRadius: CGFloat, size: CGSize) {
        self.init(texture: texture, color: .clear, size: texture.size())
        let glow: SKEffectNode = {
            let glow = SKEffectNode()
            let texture = SKSpriteNode(texture: texture)
            texture.size = size
            glow.addChild(texture)
            glow.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius": glowRadius])
            glow.shouldRasterize = true
            return glow
        }()
        let glowRoot: SKNode = {
            let node = SKNode()
            node.name = "Glow"
            return node
        }()
        glowRoot.addChild(glow)
        addChild(glowRoot)
    }
}
