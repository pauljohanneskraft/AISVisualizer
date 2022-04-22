//
//  VisualizationPage.swift
//  AISVisualizer
//
//  Created by Paul Kraft on 21.02.22.
//

import SwiftUI
import MapKit

struct VisualizationPage: View {

    // MARK: Stored Properties

    @ObservedObject var model: ReaderModel
    let map: Map

    @State private var mapType = MKMapType.satellite
    @State private var regions = [MKCoordinateRegion]()
    @State private var paths = [ShipPath]()
    @State private var grids = [MapGrid]()
    @State private var showsNewPathPopover = false
    @State private var showsNewGridPopover = false

    // MARK: Computed Properties

    var body: some View {
        MapView(mapType: mapType, paths: paths, grids: grids)
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
                    MapTypePicker(mapType: $mapType)
                        .pickerStyle(.segmented)
                }

                ToolbarItem(placement: .primaryAction) {
                    HStack {
                        Button("Center") {
                            MapView.center()
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
