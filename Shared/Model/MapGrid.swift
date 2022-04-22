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

}
