//
//  MenuViewController.swift
//  XmasCrunch
//
//  Created by Sergii Miroshnichenko on 22.12.2022.
//

import UIKit
import AVFoundation

class MenuViewController: UIViewController {
    
    let patternImage = UIImage(named: "giftIcon")
    
    lazy var animator = UIDynamicAnimator(referenceView: view)
    lazy var patternBehavior = PatternBehavior(in: animator)
    
    lazy var backgroundMusic: AVAudioPlayer? = {
      guard let url = Bundle.main.url(forResource: "menuTheme", withExtension: "mp3") else {
        return nil
      }
      do {
        let player = try AVAudioPlayer(contentsOf: url)
        player.numberOfLoops = -1
        return player
      } catch {
        return nil
      }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadPattern(with: 10)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        backgroundMusic?.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        backgroundMusic?.stop()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            case "levelNumberVC":
                if let vc = segue.destination as? ChooseLevelViewController {
                    vc.levelList = [1, 2, 3, 4, 5, 6]
                }
            default:
                break
        }
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
