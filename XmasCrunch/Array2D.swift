//
//  Array2D.swift
//  XmasCrunch
//
//  Created by Sergii Miroshnichenko on 13.12.2022.
//

/*
 Generic struct which makes it easier to create two-dimensional arrays
 */

import Foundation

struct Array2D<T> {
    
    let columns: Int
    let rows: Int
    
    private var array: Array<T?>
    
    init(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
        array = Array<T?>(repeating: nil, count: rows*columns)
    }
    
    subscript(column: Int, row: Int) -> T? {
        get {
            return array[row*columns + column]
        }
        set {
            array[row*columns + column] = newValue
        }
    }
}
