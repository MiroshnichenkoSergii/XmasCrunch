//
//  Swap.swift
//  XmasCrunch
//
//  Created by Sergii Miroshnichenko on 15.12.2022.
//

import Foundation

struct Swap: CustomStringConvertible {
    let itemXA: ItemX
    let itemXB: ItemX
    
    init(itemXA: ItemX, itemXB: ItemX) {
        self.itemXA = itemXA
        self.itemXB = itemXB
    }
    
    var description: String {
        return "swap \(itemXA) with \(itemXB)"
    }
}
