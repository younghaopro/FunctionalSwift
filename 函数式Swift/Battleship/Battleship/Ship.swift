//
//  Ship.swift
//  Battleship
//
//  Created by yanghao on 2018/4/26.
//  Copyright © 2018年 yanghao. All rights reserved.
//

import Foundation

struct Ship {
    var position: Position
    var firingRange: Distance
    var unsafeRange: Distance
}
typealias Region = (Position) -> Bool

extension Ship {
    
    func circle(radius: Distance) -> Region {
        return { point in
            point.length <= radius
        }
    }
    
    func circle2(radius: Distance, center: Position) -> Region {
        return { point in
            point.minus(center).length <= radius
        }
    }
    
    func shift(_ region: @escaping Region, by offset: Position) -> Region {
        return { point in
            region(point.minus(offset))
        }
    }
    
    func invert(_ region: @escaping Region) -> Region {
        return { point in
            !region(point)
        }
    }
    
    func intersect(_ region: @escaping Region, with other: @escaping Region) -> Region {
        return { point in
            return region(point) && other(point)
        }
    }
    
    func union(_ region: @escaping Region, with other: @escaping Region) -> Region {
        return { point in
            return region(point) || other(point)
        }
    }
    
    func subtract(_ region: @escaping Region, from original: @escaping Region) -> Region {
        return intersect(original, with: invert(region))
    }
}
extension Ship {
    func canEngaga(ship target: Ship) -> Bool {
        let dx = target.position.x - position.x
        let dy = target.position.y - position.y
        let tagertDistance = sqrt(dx * dx + dy * dy)
        return tagertDistance <= firingRange
    }
    
    func canSafelyEngage(ship target: Ship, friendly: Ship) -> Bool {
//        let tagertDistance = target.position.minus(position).length
//        let friendlyDistance = friendly.position.minus(target.position).length
//        return tagertDistance > unsafeRange && tagertDistance <= firingRange && friendlyDistance > unsafeRange
        let rangeRegion = subtract(circle(radius: unsafeRange), from: circle(radius: firingRange))
        let firingRegion = shift(rangeRegion, by: position)
        let friendlyRegion = shift(circle(radius: unsafeRange), by: friendly.position)
        let resultRegon = subtract(friendlyRegion, from: firingRegion)
        return resultRegon(target.position)
    }
}
