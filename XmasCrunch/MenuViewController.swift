//
//  MenuViewController.swift
//  XmasCrunch
//
//  Created by Sergii Miroshnichenko on 22.12.2022.
//

import UIKit

class MenuViewController: UIViewController {
    
    let patternImage = UIImage(named: "giftIcon")
    
    lazy var animator = UIDynamicAnimator(referenceView: view)
    lazy var patternBehavior = PatternBehavior(in: animator)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPattern(with: 10)
    }

    func loadPattern(with number: Int) {
        for _ in 0..<number {
            let patternView = UIImageView(image: patternImage!)
            patternView.frame = CGRect(x: Int.random(in: 0...400), y: Int.random(in: 0...780), width: 50, height: 50)
            view.addSubview(patternView)
            patternBehavior.addItem(patternView)
        }
    }
}
