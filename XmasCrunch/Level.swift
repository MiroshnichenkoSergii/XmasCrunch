//
//  Level.swift
//  XmasCrunch
//
//  Created by Sergii Miroshnichenko on 13.12.2022.
//

import Foundation

let numColumns = 9
let numRows = 9

class Level {
    
    private var itemsX = Array2D<ItemX>(columns: numColumns, rows: numRows)
    private var tiles = Array2D<Tile>(columns: numColumns, rows: numRows)
    
    func itemX(atColumn column: Int, row: Int) -> ItemX? {
      precondition(column >= 0 && column < numColumns)
      precondition(row >= 0 && row < numRows)
      return itemsX[column, row]
    }
    func tileAt(column: Int, row: Int) -> Tile? {
      precondition(column >= 0 && column < numColumns)
      precondition(row >= 0 && row < numRows)
      return tiles[column, row]
    }
    
    func shuffle() -> Set<ItemX> {
      return createInitialItemsX()
    }

    //Right Description
    private func createInitialItemsX() -> Set<ItemX> {
        var set: Set<ItemX> = []
        
        for row in 0..<numRows {
            for column in 0..<numColumns {
                
                if tiles[column, row] != nil {
                    let itemXType = ItemXType.random()
                    
                    let itemX = ItemX(column: column, row: row, itemXType: itemXType)
                    itemsX[column, row] = itemX
                    
                    set.insert(itemX)
                }
            }
        }
        return set
    }

    init(filename: String) {
        // 1
        guard let levelData = LevelData.loadFrom(file: filename) else { return }
        // 2
        let tilesArray = levelData.tiles
        // 3
        for (row, rowArray) in tilesArray.enumerated() {
            // 4
            let tileRow = numRows - row - 1
            // 5
            for (column, value) in rowArray.enumerated() {
                if value == 1 {
                    tiles[column, tileRow] = Tile()
                }
            }
        }
    }

}
