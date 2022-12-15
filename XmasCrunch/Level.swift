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
    
    private var possibleSwaps: Set<Swap> = []
    
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
        var set: Set<ItemX>
        repeat {
            set = createInitialItemsX()
            detectPossibleSwaps()
            print("possible swaps: \(possibleSwaps)")
        } while possibleSwaps.count == 0
        
        return set
    }
    
    func detectPossibleSwaps() {
        var set: Set<Swap> = []
        
        for row in 0..<numRows {
            for column in 0..<numColumns {
                if let itemX = itemsX[column, row] {
                    
                    // Have an item in this spot? If there is no tile, there is no item.
                    if column < numColumns - 1,
                       let other = itemsX[column + 1, row] {
                        // Swap them
                        itemsX[column, row] = other
                        itemsX[column + 1, row] = itemX
                        
                        // Is either item now part of a chain?
                        if hasChain(atColumn: column + 1, row: row) ||
                            hasChain(atColumn: column, row: row) {
                            set.insert(Swap(itemXA: itemX, itemXB: other))
                        }
                        
                        // Swap them back
                        itemsX[column, row] = itemX
                        itemsX[column + 1, row] = other
                    }

                    if row < numRows - 1,
                       let other = itemsX[column, row + 1] {
                        itemsX[column, row] = other
                        itemsX[column, row + 1] = itemX
                        
                        // Is either item now part of a chain?
                        if hasChain(atColumn: column, row: row + 1) ||
                            hasChain(atColumn: column, row: row) {
                            set.insert(Swap(itemXA: itemX, itemXB: other))
                        }
                        
                        // Swap them back
                        itemsX[column, row] = itemX
                        itemsX[column, row + 1] = other
                    }
                }
                else if column == numColumns - 1, let itemX = itemsX[column, row] {
                    if row < numRows - 1,
                       let other = itemsX[column, row + 1] {
                        itemsX[column, row] = other
                        itemsX[column, row + 1] = itemX
                        
                        // Is either item now part of a chain?
                        if hasChain(atColumn: column, row: row + 1) ||
                            hasChain(atColumn: column, row: row) {
                            set.insert(Swap(itemXA: itemX, itemXB: other))
                        }
                        
                        // Swap them back
                        itemsX[column, row] = itemX
                        itemsX[column, row + 1] = other
                    }
                }
            }
        }
        
        possibleSwaps = set
    }
    
    private func hasChain(atColumn column: Int, row: Int) -> Bool {
        let itemXType = itemsX[column, row]!.itemXType
        
        // Horizontal chain check
        var horizontalLength = 1
        
        // Left
        var i = column - 1
        while i >= 0 && itemsX[i, row]?.itemXType == itemXType {
            i -= 1
            horizontalLength += 1
        }
        
        // Right
        i = column + 1
        while i < numColumns && itemsX[i, row]?.itemXType == itemXType {
            i += 1
            horizontalLength += 1
        }
        if horizontalLength >= 3 { return true }
        
        // Vertical chain check
        var verticalLength = 1
        
        // Down
        i = row - 1
        while i >= 0 && itemsX[column, i]?.itemXType == itemXType {
            i -= 1
            verticalLength += 1
        }
        
        // Up
        i = row + 1
        while i < numRows && itemsX[column, i]?.itemXType == itemXType {
            i += 1
            verticalLength += 1
        }
        return verticalLength >= 3
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
    
    func isPossibleSwap(_ swap: Swap) -> Bool {
        return possibleSwaps.contains(swap)
    }
    
    private func detectHorizontalMatches() -> Set<Chain> {
        var set: Set<Chain> = []
        
        for row in 0..<numRows {
            var column = 0
            
            while column < numColumns-2 {
                
                if let itemX = itemsX[column, row] {
                    let matchType = itemX.itemXType
                    
                    if itemsX[column + 1, row]?.itemXType == matchType &&
                        itemsX[column + 2, row]?.itemXType == matchType {
                        
                        let chain = Chain(chainType: .horizontal)
                        
                        repeat {
                            chain.add(itemX: itemsX[column, row]!)
                            column += 1
                        } while column < numColumns && itemsX[column, row]?.itemXType == matchType
                        
                        set.insert(chain)
                        continue
                    }
                }
                column += 1
            }
        }
        return set
    }
    
    private func detectVerticalMatches() -> Set<Chain> {
        var set: Set<Chain> = []
        
        for column in 0..<numColumns {
            var row = 0
            
            while row < numRows-2 {
                if let itemX = itemsX[column, row] {
                    let matchType = itemX.itemXType
                    
                    if itemsX[column, row + 1]?.itemXType == matchType &&
                        itemsX[column, row + 2]?.itemXType == matchType {
                        let chain = Chain(chainType: .vertical)
                        repeat {
                            chain.add(itemX: itemsX[column, row]!)
                            row += 1
                        } while row < numRows && itemsX[column, row]?.itemXType == matchType
                        
                        set.insert(chain)
                        continue
                    }
                }
                row += 1
            }
        }
        return set
    }
    
    func removeMatches() -> Set<Chain> {
        let horizontalChains = detectHorizontalMatches()
        let verticalChains = detectVerticalMatches()
        
        removeItemsX(in: horizontalChains)
        removeItemsX(in: verticalChains)
        
        return horizontalChains.union(verticalChains)
    }
    
    private func removeItemsX(in chains: Set<Chain>) {
        for chain in chains {
            for itemX in chain.itemsX {
                itemsX[itemX.column, itemX.row] = nil
            }
        }
    }
    
    func fillHoles() -> [[ItemX]] {
        var columns: [[ItemX]] = []
        
        for column in 0..<numColumns {
            var array: [ItemX] = []
            for row in 0..<numRows {
                if tiles[column, row] != nil && itemsX[column, row] == nil {
                    for lookup in (row + 1)..<numRows {
                        if let itemX = itemsX[column, lookup] {
                            itemsX[column, lookup] = nil
                            itemsX[column, row] = itemX
                            itemX.row = row
                            array.append(itemX)
                            break
                        }
                    }
                }
            }
            if !array.isEmpty {
                columns.append(array)
            }
        }
        return columns
    }
    
    func topUpItemsX() -> [[ItemX]] {
        var columns: [[ItemX]] = []
        var itemXType: ItemXType = .unknown
        
        for column in 0..<numColumns {
            var array: [ItemX] = []
            var row = numRows - 1
            
            while row >= 0 && itemsX[column, row] == nil {
                if tiles[column, row] != nil {
                    var newItemXType: ItemXType
                    
                    repeat {
                        newItemXType = ItemXType.random()
                    } while newItemXType == itemXType
                    itemXType = newItemXType
                    
                    let itemX = ItemX(column: column, row: row, itemXType: itemXType)
                    
                    itemsX[column, row] = itemX
                    array.append(itemX)
                }
                row -= 1
            }
            if !array.isEmpty {
                columns.append(array)
            }
        }
        return columns
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
