//
//  MKCoordinateRegion.swift
//  AISVisualizer
//
//  Created by Paul Kraft on 22.04.22.
//

import Foundation
import MapKit

extension MKCoordinateRegion {

    var northEast: CLLocationCoordinate2D {
        .init(
            latitude: center.latitude + span.latitudeDelta / 2,
            longitude: center.longitude + span.longitudeDelta / 2
        )
    }

    var northWest: CLLocationCoordinate2D {
        .init(
            latitude: center.latitude + span.latitudeDelta / 2,
            longitude: center.longitude - span.longitudeDelta / 2
        )
    }

    var southEast: CLLocationCoordinate2D {
        .init(
            latitude: center.latitude - span.latitudeDelta / 2,
            longitude: center.longitude + span.longitudeDelta / 2
        )
    }

    var southWest: CLLocationCoordinate2D {
        .init(
            latitude: center.latitude - span.latitudeDelta / 2,
            longitude: center.longitude - span.longitudeDelta / 2
        )
    }

}
