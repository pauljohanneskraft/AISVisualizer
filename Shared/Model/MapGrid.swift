//
//  MapGrid.swift
//  AISVisualizer
//
//  Created by Paul Kraft on 22.04.22.
//

import Foundation
import SwiftUI
import MapKit

struct MapGrid: Equatable {

    // MARK: Stored Properties

    var northLatitude = 50.0
    var westLongitude = -140.0
    var southLatitude = 25.0
    var eastLongitude = -70.0

    var latitudinalCount = 10
    var longitudinalCount = 10
    var overlap = 10

    var outerColor = Color.white.opacity(0.3)
    var innerColor = Color.red.opacity(0.6)

    // MARK: Computed Properties

    var latitudeDelta: Double {
        abs(northLatitude - southLatitude)
    }

    var longitudeDelta: Double {
        abs(westLongitude - eastLongitude)
    }

    var center: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: (northLatitude + southLatitude) / 2,
            longitude: (westLongitude + eastLongitude) / 2
        )
    }

    var regions: [MKCoordinateRegion] {
        let itemLatitudeDelta = latitudeDelta / Double(latitudinalCount)
        let itemLongitudeDelta = longitudeDelta / Double(longitudinalCount)

        return (0..<latitudinalCount).flatMap { latitudinalIndex in
            (0..<longitudinalCount).map { longitudinalIndex in
                MKCoordinateRegion(
                    center: .init(
                        latitude: southLatitude + (Double(latitudinalIndex) + 0.5) * itemLatitudeDelta,
                        longitude: westLongitude + (Double(longitudinalIndex) + 0.5) * itemLongitudeDelta
                    ),
                    span: .init(
                        latitudeDelta: itemLatitudeDelta,
                        longitudeDelta: itemLongitudeDelta
                    )
                )
            }
        }
    }

    var regionsWithEqualOverlap: [MKCoordinateRegion] {
        let spanMultiplier = 1 + Double(overlap) * 2 / 100
        return regions.map { region in
            MKCoordinateRegion(
                center: region.center,
                span: .init(
                    latitudeDelta: region.span.latitudeDelta * spanMultiplier,
                    longitudeDelta: region.span.longitudeDelta * spanMultiplier
                )
            )
        }
    }

    var totalRegion: MKCoordinateRegion {
        .init(
            center: center,
            span: .init(
                latitudeDelta: latitudeDelta,
                longitudeDelta: longitudeDelta
            )
        )
    }

    // MARK: Methods

    func validate() -> String? {
        guard northLatitude > southLatitude else {
            return "The north value must be larger than the south value."
        }
        guard eastLongitude > westLongitude else {
            return "The east value must be larger than the west value."
        }
        guard (-90...90).contains(northLatitude) else {
            return "Invalid north value."
        }
        guard (-90...90).contains(southLatitude) else {
            return "Invalid south value."
        }
        guard (-180...180).contains(westLongitude) else {
            return "Invalid west value."
        }
        guard (-180...180).contains(eastLongitude) else {
            return "Invalid east value."
        }
        guard (0...50).contains(overlap) else {
            return "Invalid overlap value."
        }
        guard (1...100).contains(latitudinalCount) else {
            return "Invalid row count."
        }
        guard (1...100).contains(longitudinalCount) else {
            return "Invalid column count."
        }
        return nil
    }

}
