//
//  GameViewController.swift
//  XmasCrunch
//
//  Created by Sergii Miroshnichenko on 09.12.2022.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class GameViewController: UIViewController {

    var level: Level!
    
    // MARK: Properties
    var scene: GameScene!
    
    lazy var backgroundMusic: AVAudioPlayer? = {
      guard let url = Bundle.main.url(forResource: "mainTheme", withExtension: "mp3") else {
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
    
    // MARK: Outlets
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false
        
        // Create and configure the scene.
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        
        scene.swipeHandler = handleSwipe
        
        // Present the scene.
        skView.presentScene(scene)
        
        // Start the background music.
//        backgroundMusic?.play()
        
        level = Level(filename: "Level_0")
        scene.level = level
        
        scene.addTiles()

        beginGame()
    }
    
    // MARK: Action buttons
    @IBAction func shuffleButtonPaped(_ sender: UIButton) {
    }
    
    func beginGame() {
        shuffle()
    }
    
    func shuffle() {
        let newItemsX = level.shuffle()
        scene.addSprites(for: newItemsX)
    }
    
    func handleSwipe(_ swap: Swap) {
        view.isUserInteractionEnabled = false
        
        if level.isPossibleSwap(swap) {
            level.performSwap(swap)
            scene.animate(swap, completion: handleMatches)
        } else {
            scene.animateInvalidSwap(swap) {
                self.view.isUserInteractionEnabled = true
            }
        }
    }
    
    func handleMatches() {
        let chains = level.removeMatches()
        // TODO: do something with the chains set
    }

}
