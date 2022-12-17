//
//  ItemX.swift
//  XmasCrunch
//
//  Created by Sergii Miroshnichenko on 13.12.2022.
//

import Foundation
import SpriteKit

// MARK: - ItemXType
enum ItemXType: Int {
    case unknown = 0, candy, firework, iceskates, snow, starball, xTree
    
//        case unknown = 0, boots, cakeman, candy, firebox, firework, glave, hat, iceskates, light, snow, snowhouse, starball, wreth, xTree
    
    var spriteName: String {
      let spriteNames = [
        "candy",
        "firework",
        "iceskates",
        "snow",
        "starball",
        "xTree"]

      return spriteNames[rawValue - 1]
    }

    var highlightedSpriteName: String {
      return spriteName + "HiLi"
    }
    
    static func random() -> ItemXType {
      return ItemXType(rawValue: Int(arc4random_uniform(6)) + 1)!
    }
}
    
// MARK: - ItemX
class ItemX: CustomStringConvertible, Hashable {
    
    var hashValue: Int {
        return row * 10 + column
    }
    
    func hash(into hasher: inout Hasher) {
        column.hash(into: &hasher)
        row.hash(into: &hasher)
    }
    
    static func ==(lhs: ItemX, rhs: ItemX) -> Bool {
        return lhs.column == rhs.column && lhs.row == rhs.row
        
    }
    
    var description: String {
        return "type:\(itemXType) square:(\(column),\(row))"
    }
    
    var column: Int
    var row: Int
    let itemXType: ItemXType
    var sprite: SKSpriteNode?
    
    init(column: Int, row: Int, itemXType: ItemXType) {
        self.column = column
        self.row = row
        self.itemXType = itemXType
    }
}


