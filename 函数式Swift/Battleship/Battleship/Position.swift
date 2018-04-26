//
//  Position.swift
//  Battleship
//
//  Created by yanghao on 2018/4/26.
//  Copyright © 2018年 yanghao. All rights reserved.
//

import Foundation

typealias Distance = Double

struct Position {
    var x: Double
    var y: Double
}

extension Position {
    func within(range: Distance) -> Bool {
        return sqrt(x * x + y * y) <= range
    }
}

extension Position {
    func minus(_ p: Position) -> Position {
        return Position(x: x - p.x, y: y - p.y)
    }
    
    var length: Distance {
        return sqrt(x * x + y * y)
    }
    
}


