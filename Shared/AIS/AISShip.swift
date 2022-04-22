//
//  Ship.swift
//  AISVisualizer
//
//  Created by Paul Kraft on 03.02.22.
//

import Foundation

struct AISShip: Equatable, Hashable {

    // MARK: Static Functions

    static func == (lhs: AISShip, rhs: AISShip) -> Bool {
        lhs.mmsi == rhs.mmsi
    }

    // MARK: Stored Properties

    let mmsi: Int
    let name: String
    var length: Double?
    var width: Double?
    var vesselType: Int?
    var positions: [AISPosition]

}
