//
//  VisualizationPage.swift
//  AISVisualizer
//
//  Created by Paul Kraft on 21.02.22.
//

import Map
import MapKit
import SwiftUI

struct VisualizationPage: View {

    // MARK: Nested Types

    private enum OverlayItem: Identifiable {

        // MARK: Cases

        case path(ShipPath)
        case grid(MapGrid, isOverlap: Bool)

        // MARK: Computed Properties

        var id: String {
            switch self {
            case let .path(path):
                return path.id.uuidString
            case let .grid(grid, isOverlap):
                return grid.id.uuidString + (isOverlap ? "-1" : "-2")
            }
        }

        var overlay: MapOverlay {
            switch self {
            case let .path(path):
                return MapPolyline(
                    coordinates: path.positions.map { CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude) },
                    strokeColor: path.color,
                    lineWidth: 4
                )
            case let .grid(grid, isOverlap):
                if isOverlap {
                    let totalRegion = grid.totalRegion
                    let latitudeRange = totalRegion.southWest.latitude...totalRegion.northEast.latitude
                    let longitudeRange = totalRegion.southWest.longitude...totalRegion.northEast.longitude
                    let polylines = grid.regionsWithEqualOverlap.map { region -> MKPolyline in
                        let coordinates = [region.northWest, region.northEast, region.southEast, region.southWest, region.northWest].map {
                            CLLocationCoordinate2D(latitude: latitudeRange.clamp($0.latitude), longitude: longitudeRange.clamp($0.longitude))
                        }
                        return MKPolyline(coordinates: coordinates, count: coordinates.count)
                    }
                    return MapMultiPolyline(polylines: polylines, lineWidth: 4, strokeColor: grid.outerColor)
                } else {
                    let polylines = grid.regions.map { region -> MKPolyline in
                        let coordinates = [region.northWest, region.northEast, region.southEast, region.southWest, region.northWest]
                        return MKPolyline(coordinates: coordinates, count: coordinates.count)
                    }
                    return MapMultiPolyline(polylines: polylines, lineWidth: 4, strokeColor: grid.innerColor)
                }
            }
        }

        var boundingMapRect: MKMapRect {
            overlay.overlay.boundingMapRect
        }

    }

    // MARK: Stored Properties

    @ObservedObject var model: ReaderModel
    let map: AISMap

    @State private var mapRect = MKMapRect.world
    @State private var mapType = MKMapType.satellite
    @State private var paths = [ShipPath]()
    @State private var grids = [MapGrid]()
    @State private var showsNewPathPopover = false
    @State private var showsNewGridPopover = false

    // MARK: Computed Properties

    private var overlayItems: [OverlayItem] {
        paths.map(OverlayItem.path)
            + grids.map { OverlayItem.grid($0, isOverlap: true) }
            + grids.map { OverlayItem.grid($0, isOverlap: false) }
    }

    var body: some View {
        Map(
            mapRect: $mapRect,
            type: mapType,
            overlayItems: overlayItems,
            overlayContent: { item in
                item.overlay
            }
        )
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                HStack {
                    Button("Close") {
                        model.reset()
                    }

                    Button("Reset") {
                        paths.removeAll()
                        grids.removeAll()
                    }
                    .disabled(paths.isEmpty && grids.isEmpty)
                }
            }

            ToolbarItem(placement: .principal) {
                #if os(macOS)
                MapTypePicker(mapType: $mapType)
                    .pickerStyle(.segmented)
                #else
                if UIDevice.current.userInterfaceIdiom == .phone {
                    MapTypePicker(mapType: $mapType)
                } else {
                    MapTypePicker(mapType: $mapType)
                        .pickerStyle(.segmented)
                }
                #endif
            }

            ToolbarItem(placement: .primaryAction) {
                HStack {
                    Button("Center") {
                        let boundingMapRect = overlayItems.reduce(nil) { accumulator, item in
                            accumulator.map { $0.union(item.boundingMapRect) }
                            ?? item.boundingMapRect
                        } ?? .world

                        withAnimation {
                            mapRect = boundingMapRect.insetBy(
                                dx: -boundingMapRect.width / 4,
                                dy: -boundingMapRect.height / 4
                            )
                        }
                    }
                    .disabled(paths.isEmpty && grids.isEmpty)

                    Button("Add Path") {
                        showsNewPathPopover = true
                    }
                    .popover(isPresented: $showsNewPathPopover) {
                        NewPathPopover(map: map, paths: $paths)
                    }

                    Button("Add Grid") {
                        showsNewGridPopover = true
                    }
                    .popover(isPresented: $showsNewGridPopover) {
                        NewGridPopover(grids: $grids)
                    }
                }
            }
        }
        #if !os(macOS)
        .ignoresSafeArea(.all, edges: [.horizontal, .bottom])
        #endif
    }

}
