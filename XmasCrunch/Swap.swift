//
//  Swap.swift
//  XmasCrunch
//
//  Created by Sergii Miroshnichenko on 15.12.2022.
//

import Foundation

struct Swap: CustomStringConvertible, Hashable {
    let itemXA: ItemX
    let itemXB: ItemX
    
    init(itemXA: ItemX, itemXB: ItemX) {
        self.itemXA = itemXA
        self.itemXB = itemXB
    }
    
    var description: String {
        return "swap \(itemXA) with \(itemXB)"
    }
    
    var hashValue: Int {
        return itemXA.hashValue ^ itemXB.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        itemXA.hash(into: &hasher)
        itemXB.hash(into: &hasher)
    }
    
    static func ==(lhs: Swap, rhs: Swap) -> Bool {
        return (lhs.itemXA == rhs.itemXA && lhs.itemXB == rhs.itemXB) ||
        (lhs.itemXB == rhs.itemXA && lhs.itemXA == rhs.itemXB)
    }

}
