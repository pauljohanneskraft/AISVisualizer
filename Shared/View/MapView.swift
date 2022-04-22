//
//  MapView.swift
//  AISVisualizer
//
//  Created by Paul Kraft on 06.02.22.
//

import Combine
import SwiftUI
import MapKit

struct MapView {

    // MARK: Static Properties

    private static let centerNotification = Notification.Name("__MAPVIEW_CENTER__")

    // MARK: Static Functions

    static func center() {
        NotificationCenter.default.post(name: MapView.centerNotification, object: nil)
    }

    // MARK: Nested Types

    private class ColorPolyline: MKPolyline {
        var strokeColor: Color?
        var lineWidth: CGFloat?
    }

    private class ColorPolygon: MKPolygon {
        var fillColor: Color?
    }

    class Coordinator: NSObject, MKMapViewDelegate {

        // MARK: Stored Properties

        private var view: MapView
        private var cancellables = Set<AnyCancellable>()
        private weak var mapView: MKMapView?

        // MARK: Initialization

        init(view: MapView) {
            self.view = view

            super.init()

            NotificationCenter.default.publisher(for: MapView.centerNotification)
                .sink { [unowned self] _ in centerMap() }
                .store(in: &cancellables)
        }

        // MARK: Methods

        func update(_ mapView: MKMapView, with view: MapView, context: Context) {
            defer {
                self.mapView = mapView
                self.view = view
            }

            if view.paths != self.view.paths || view.grids != self.view.grids {
                updateOverlays(with: view)
            }

            if mapView.mapType != view.mapType {
                mapView.mapType = view.mapType
            }
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .init((polyline as? ColorPolyline)?.strokeColor ?? Constants.defaultPolylineStrokeColor)
                renderer.lineWidth = (polyline as? ColorPolyline)?.lineWidth ?? 4
                return renderer
            }
            if let polygon = overlay as? MKPolygon {
                let renderer = MKPolygonRenderer(polygon: polygon)
                renderer.fillColor = .init((polygon as? ColorPolygon)?.fillColor ?? Constants.defaultPolygonFillColor)
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }

        // MARK: Helpers

        private func updateOverlays(with view: MapView) {
            guard let mapView = mapView else {
                return
            }

            let pathOverlays = view.paths.map { path -> MKPolyline in
                let coordinates = path.positions.map { CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude) }
                let line = ColorPolyline(coordinates: coordinates, count: coordinates.count)
                line.strokeColor = path.color
                return line
            }

            let outerRangeOverlays = view.grids.flatMap { grid -> [MKOverlay] in
                let totalRegion = grid.totalRegion
                let latitudeRange = totalRegion.southWest.latitude...totalRegion.northEast.latitude
                let longitudeRange = totalRegion.southWest.longitude...totalRegion.northEast.longitude
                return grid.regionsWithEqualOverlap.map { region in
                    let coordinates = [region.northWest, region.northEast, region.southEast, region.southWest, region.northWest].map {
                        CLLocationCoordinate2D(latitude: latitudeRange.clamp($0.latitude), longitude: longitudeRange.clamp($0.longitude))
                    }
                    let line = ColorPolyline(coordinates: coordinates, count: coordinates.count)
                    line.strokeColor = grid.outerColor
                    return line
                }
            }

            let innerRangeOverlays = view.grids.flatMap { grid -> [MKOverlay] in
                grid.regions.map { region in
                    let coordinates = [region.northWest, region.northEast, region.southEast, region.southWest, region.northWest]
                    let line = ColorPolyline(coordinates: coordinates, count: coordinates.count)
                    line.strokeColor = grid.innerColor
                    return line
                }
            }

            mapView.removeOverlays(mapView.overlays)
            mapView.addOverlays(outerRangeOverlays + innerRangeOverlays + pathOverlays)
        }

        private func centerMap() {
            guard let mapView = mapView else {
                return
            }

            let mapRect = mapView.overlays.reduce(nil) { accumulator, overlay in
                accumulator.map { overlay.boundingMapRect.union($0) } ?? overlay.boundingMapRect
            }

            if let rect = mapRect {
                mapView.setVisibleMapRect(rect, animated: true)
            }
        }

    }

    // MARK: Stored Properties

    let mapType: MKMapType
    let paths: [ShipPath]
    let grids: [MapGrid]

    // MARK: Methods

    func makeCoordinator() -> Coordinator {
        .init(view: self)
    }

}

#if canImport(AppKit)

extension MapView: NSViewRepresentable {

    func makeNSView(context: Context) -> MKMapView {
        let view = MKMapView()
        view.delegate = context.coordinator
        view.mapType = .satelliteFlyover
        updateNSView(view, context: context)
        return view
    }

    func updateNSView(_ view: MKMapView, context: Context) {
        context.coordinator.update(view, with: self, context: context)
    }

}

#elseif canImport(UIKit)

extension MapView: UIViewRepresentable {

    func makeUIView(context: Context) -> MKMapView {
        let view = MKMapView()
        view.delegate = context.coordinator
        view.mapType = .satelliteFlyover
        updateUIView(view, context: context)
        return view
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        context.coordinator.update(view, with: self, context: context)
    }

}

#endif
