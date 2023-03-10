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
    
    // MARK: - Properties
    var level: Level!
    var scene: GameScene!
    
    var movesLeft = 0
    var score = 0
    var currentLevelNumber = Setting.shared.currentSettings.level
    
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    lazy var backgroundMusic: AVAudioPlayer? = {
        guard let url = Bundle.main.url(forResource: "mainTheme", withExtension: "mp3") else {
            return nil
        }
        do {
            if Setting.shared.currentSettings.music {
                let player = try AVAudioPlayer(contentsOf: url)
                player.numberOfLoops = -1
                return player
            }
            return nil
        } catch {
            return nil
        }
    }()
    
    // MARK: - Outlets
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet weak var gameOverPanel: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup view with level 1
        setupLevel(number: currentLevelNumber)
        
        // Start the background music.
        backgroundMusic?.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        backgroundMusic?.stop()
    }
    
    // MARK: - Action buttons
    @IBAction func shuffleButtonPaped(_ sender: UIButton) {
        scene.removeAllItemsXSprites()
        shuffle()
        decrementMoves()
    }
    
    // MARK: - Functions
    func setupLevel(number levelNumber: Int) {
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false
        
        // Create and configure the scene.
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        
        // Setup the level.
        level = Level(filename: "Level_\(levelNumber)")
        scene.level = level
        
        scene.addTiles()
        scene.swipeHandler = handleSwipe
        
        gameOverPanel.isHidden = true
        shuffleButton.isHidden = true
        
        // Present the scene.
        skView.presentScene(scene)
        
        // Start the game.
        beginGame()
    }
    
    func beginGame() {
        movesLeft = level.maximumMoves
        score = 0
        updateLabels()

        level.resetComboMultiplier()

        scene.animateBeginGame { self.shuffleButton.isHidden = false }
        scene.removeAllItemsXSprites()

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
        
        if chains.count == 0 {
            beginNextTurn()
            return
        }

        scene.animateMatchedItemsX(for: chains) {
            
            for chain in chains {
              self.score += chain.score
            }
            self.updateLabels()

            let columns = self.level.fillHoles()
            self.scene.animateFallingItemsX(in: columns) {
                let columns = self.level.topUpItemsX()
                self.scene.animateNewItemsX(in: columns) {
                    self.handleMatches()
                }
            }
        }
    }

    func beginNextTurn() {
        level.detectPossibleSwaps()
        view.isUserInteractionEnabled = true
        decrementMoves()
    }
    
    func updateLabels() {
        targetLabel.text = String(format: "%ld", level.targetScore)
        movesLabel.text = String(format: "%ld", movesLeft)
        scoreLabel.text = String(format: "%ld", score)
    }
    
    func decrementMoves() {
        movesLeft -= 1
        updateLabels()
        
        if score >= level.targetScore {
            gameOverPanel.image = UIImage(named: "NextLevel")
            currentLevelNumber = currentLevelNumber < numLevels ? currentLevelNumber + 1 : 1
            showGameOver()
        } else if movesLeft == 0 {
            gameOverPanel.image = UIImage(named: "GameOver")
            showGameOver()
        }
    }

    func showGameOver() {
        shuffleButton.isHidden = true

        gameOverPanel.isHidden = false
        scene.isUserInteractionEnabled = false
        
        scene.animateGameOver {
            self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideGameOver))
            self.view.addGestureRecognizer(self.tapGestureRecognizer)
        }
    }

    @objc func hideGameOver() {
        view.removeGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = nil
        
        gameOverPanel.isHidden = true
        scene.isUserInteractionEnabled = true
        
        setupLevel(number: currentLevelNumber)
    }

}
