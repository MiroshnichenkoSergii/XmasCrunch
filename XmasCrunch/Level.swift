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
    
    func performSwap(_ swap: Swap) {
        let columnA = swap.itemXA.column
        let rowA = swap.itemXA.row
        let columnB = swap.itemXB.column
        let rowB = swap.itemXB.row
        
        itemsX[columnA, rowA] = swap.itemXB
        swap.itemXB.column = columnA
        swap.itemXB.row = rowA
        
        itemsX[columnB, rowB] = swap.itemXA
        swap.itemXA.column = columnB
        swap.itemXA.row = rowB
    }

    //Right Description
    private func createInitialItemsX() -> Set<ItemX> {
        var set: Set<ItemX> = []
        
        for row in 0..<numRows {
            for column in 0..<numColumns {
                
                if tiles[column, row] != nil {
                    var itemXType: ItemXType
                    
                    repeat {
                        itemXType = ItemXType.random()
                    } while (column >= 2 &&
                             itemsX[column - 1, row]?.itemXType == itemXType &&
                             itemsX[column - 2, row]?.itemXType == itemXType)
                    || (row >= 2 &&
                        itemsX[column, row - 1]?.itemXType == itemXType &&
                        itemsX[column, row - 2]?.itemXType == itemXType)
                    
                    let itemX = ItemX(column: column, row: row, itemXType: itemXType)
                    itemsX[column, row] = itemX
                    
                    set.insert(itemX)
                }
            }
        }
        return set
    }

    init(filename: String) {
        guard let levelData = LevelData.loadFrom(file: filename) else { return }
        
        let tilesArray = levelData.tiles
        
        for (row, rowArray) in tilesArray.enumerated() {
            let tileRow = numRows - row - 1
            for (column, value) in rowArray.enumerated() {
                if value == 1 {
                    tiles[column, tileRow] = Tile()
                }
            }
        }
    }

}
