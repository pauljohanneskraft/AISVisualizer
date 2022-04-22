//
//  AISPosition.swift
//  AISVisualizer
//
//  Created by Paul Kraft on 03.02.22.
//

import Foundation

struct AISPosition: Hashable {

    // MARK: Stored Properties

    let coordinate: Coordinate
    let date: AISDate

    // MARK: Computed Properties

    var actualPosition: Position? {
        guard let actualDate = date.actualDate else {
            return nil
        }
        return Position(coordinate: coordinate, date: actualDate)
    }

}
