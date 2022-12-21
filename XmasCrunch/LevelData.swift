//
//  LevelData.swift
//  XmasCrunch
//
//  Created by Sergii Miroshnichenko on 13.12.2022.
//

/*
 Loading data from file
 */

import Foundation

class LevelData: Codable {
  let tiles: [[Int]]
  let targetScore: Int
  let moves: Int
  
  static func loadFrom(file filename: String) -> LevelData? {
    var data: Data
    var levelData: LevelData?
    
    if let path = Bundle.main.url(forResource: filename, withExtension: "json") {
        
      do {
        data = try Data(contentsOf: path)
      }
      catch {
        print("Could not load level file: \(filename), error: \(error)")
        return nil
      }
        
      do {
        levelData = try JSONDecoder().decode(LevelData.self, from: data)
      }
      catch {
        print("Level file '\(filename)' is not valid JSON: \(error)")
        return nil
      }
    }
    return levelData
  }
}
