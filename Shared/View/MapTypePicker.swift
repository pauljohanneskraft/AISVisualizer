//
//  MapTypePicker.swift
//  AISVisualizer
//
//  Created by Paul Kraft on 22.04.22.
//

import MapKit
import SwiftUI

struct MapTypePicker: View {

    // MARK: Stored Properties

    @Binding var mapType: MKMapType

    // MARK: Computed Properties

    var body: some View {
        Picker("Map Type", selection: $mapType) {
            Text("Standard")
                .tag(MKMapType.standard)
            Text("Satellite")
                .tag(MKMapType.satellite)
            Text("Hybrid")
                .tag(MKMapType.hybrid)
            Text("Satellite Flyover")
                .tag(MKMapType.satelliteFlyover)
            Text("Hybrid Flyover")
                .tag(MKMapType.hybridFlyover)
            Text("Muted Standard")
                .tag(MKMapType.mutedStandard)
        }
    }

}
