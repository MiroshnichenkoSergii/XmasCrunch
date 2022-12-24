//
//  PatternBehavior.swift
//  XmasCrunch
//
//  Created by Sergii Miroshnichenko on 24.12.2022.
//

import Foundation
import UIKit

class PatternBehavior: UIDynamicBehavior {
    
    lazy var collisinBehavior: UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        return behavior
    }()
    
    lazy var itemBehavior: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = true
        behavior.elasticity = 1.0
        behavior.resistance = 0
        return behavior
    }()
    
    private func push(_ item: UIDynamicItem) {
        let push = UIPushBehavior(items: [item], mode: .instantaneous)
        
        if let referenceBounds = dynamicAnimator?.referenceView?.bounds {
            let center = CGPoint(x: referenceBounds.midX, y: referenceBounds.midY)
            switch (item.center.x, item.center.y) {
            case let (x,y) where x < center.x && y < center.y:
                push.angle = CGFloat.random(in: 0...CGFloat.pi/2)
            case let (x,y) where x > center.x && y < center.y:
                push.angle = CGFloat.pi - CGFloat.random(in: 0...CGFloat.pi/2)
            case let (x,y) where x < center.x && y > center.y:
                push.angle = -CGFloat.random(in: 0...CGFloat.pi/2)
            case let (x,y) where x > center.x && y > center.y:
                push.angle = CGFloat.pi + CGFloat.random(in: 0...CGFloat.pi/2)
            default:
                push.angle = CGFloat.random(in: 1...CGFloat.pi*2)
            }
        }
        
        push.magnitude = CGFloat(1.0) + CGFloat.random(in: 0...2)
        push.action = { [unowned push, weak self] in
            self?.removeChildBehavior(push)
        }
        addChildBehavior(push)
    }
    
    func addItem(_ item: UIDynamicItem) {
        collisinBehavior.addItem(item)
        itemBehavior.addItem(item)
        push(item)
    }
    
    func removeItem(_ item: UIDynamicItem) {
        collisinBehavior.removeItem(item)
        itemBehavior.removeItem(item)
    }
    
    override init() {
        super.init()
        addChildBehavior(collisinBehavior)
        addChildBehavior(itemBehavior)
    }
    
    convenience init(in animator: UIDynamicAnimator) {
        self.init()
        animator.addBehavior(self)
    }
}
