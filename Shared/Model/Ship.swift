//
//  ShipManager.swift
//  AISVisualizer
//
//  Created by Paul Kraft on 03.02.22.
//

import Foundation
import CoreLocation

actor Ship {

    // MARK: Stored Properties

    let ship: AISShip
    private var positions: [Position]

    // MARK: Initialization

    init(ais ship: AISShip) {
        self.ship = ship
        self.positions = ship.positions
            .compactMap { $0.actualPosition }
            .sorted { $0.date < $1.date }
    }

    // MARK: Methods

    func coordinate(at date: Date) -> Coordinate? {
        guard let index = positions.firstIndex(where: { $0.date >= date }) else {
            return nil
        }

        let position = positions[index]
        if index == positions.startIndex {
            return nil
        }

        let prevPosition = positions[positions.index(before: index)]
        let totalTime = position.date.timeIntervalSince(prevPosition.date)
        guard totalTime > Constants.minimumCoordinateTimeDifference else {
            return prevPosition.coordinate
        }
        let prevFraction = date.timeIntervalSince(prevPosition.date) / totalTime

        assert((0...1).contains(prevFraction))

        let coordinate = Coordinate(
            latitude: prevFraction * prevPosition.coordinate.latitude + (1 - prevFraction) * position.coordinate.latitude,
            longitude: prevFraction * prevPosition.coordinate.longitude + (1 - prevFraction) * position.coordinate.longitude
        )

        positions.insert(Position(coordinate: coordinate, date: date), at: index)
        return coordinate
    }

}
