//
//  ShipPath.swift
//  AISVisualizer
//
//  Created by Paul Kraft on 21.02.22.
//

import SwiftUI

struct ShipPath: Equatable, Identifiable {

    // MARK: Static Functions

    static func ==(lhs: ShipPath, rhs: ShipPath) -> Bool {
        lhs.positions == rhs.positions
    }

    // MARK: Stored Properties

    var id = UUID()
    let ship: Ship
    let positions: [Position]
    let color: Color

}
