//
//  Chain.swift
//  XmasCrunch
//
//  Created by Sergii Miroshnichenko on 15.12.2022.
//

import Foundation

class Chain: Hashable, CustomStringConvertible {
    var itemsX: [ItemX] = []
    var score = 0
    
    enum ChainType: CustomStringConvertible {
        case horizontal
        case vertical
        
        var description: String {
            switch self {
                case .horizontal: return "Horizontal"
                case .vertical: return "Vertical"
            }
        }
    }
    
    var chainType: ChainType
    
    init(chainType: ChainType) {
        self.chainType = chainType
    }
    
    func add(itemX: ItemX) {
        itemsX.append(itemX)
    }
    
    func firstItemX() -> ItemX {
        return itemsX[0]
    }
    
    func lastItemX() -> ItemX {
        return itemsX[itemsX.count - 1]
    }
    
    var length: Int {
        return itemsX.count
    }
    
    var description: String {
        return "type:\(chainType) itemsX:\(itemsX)"
    }
    
    var hashValue: Int {
        return itemsX.reduce (0) { $0.hashValue ^ $1.hashValue }
    }
    
    func hash(into hasher: inout Hasher) {
        itemsX.hash(into: &hasher)
    }
    
    static func ==(lhs: Chain, rhs: Chain) -> Bool {
        return lhs.itemsX == rhs.itemsX
    }
}

