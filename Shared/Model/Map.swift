//
//  Map.swift
//  AISVisualizer
//
//  Created by Paul Kraft on 03.02.22.
//

import Foundation
import SwiftUI

actor Map {

    // MARK: Stored Properties

    private(set) var dateRange: AISDateRange?
    private(set) var ships = [Int: AISShip]()

    // MARK: Methods

    func read(ais row: AISRow) {
        let coordinate = Coordinate(latitude: row.latitude, longitude: row.longitude)
        let position = AISPosition(coordinate: coordinate, date: row.date)

        dateRange = AISDateRange(
            start: min(dateRange?.start ?? row.date, row.date),
            end: max(dateRange?.end ?? row.date, row.date)
        )

        var ship = ships[row.mmsi] ?? AISShip(mmsi: row.mmsi, name: row.vesselName, length: row.length, width: row.width, vesselType: row.vesselType, positions: [])
        ship.length = ship.length ?? row.length
        ship.width = ship.width ?? row.width
        ship.vesselType = ship.vesselType ?? row.vesselType
        ship.positions.append(position)
        ships[row.mmsi] = ship
    }

    func path(mmsi: Int, start: Date, interval: TimeInterval, end: Date, color: Color) async -> ShipPath? {
        guard let ship = ships[mmsi].map(Ship.init) else {
            return nil
        }

        var positions = [Position]()
        var date = start

        while date < end {
            defer  { date.addTimeInterval(interval) }
            guard let coordinate = await ship.coordinate(at: date) else {
                continue
            }
            positions.append(Position(coordinate: coordinate, date: date))
        }

        return .init(ship: ship, positions: positions, color: color)
    }

}
