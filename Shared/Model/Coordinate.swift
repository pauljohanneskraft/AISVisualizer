//
//  Coordinate.swift
//  AISVisualizer
//
//  Created by Paul Kraft on 03.02.22.
//

import Foundation

struct Coordinate: CustomStringConvertible, Hashable, Equatable {

    // MARK: Stored Properties

    let latitude: Double
    let longitude: Double

    // MARK: Computed Properties

    var description: String {
        "(latitude: \(latitude), longitude: \(longitude))"
    }

}
