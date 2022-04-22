//
//  NewGridPopover.swift
//  AISVisualizer
//
//  Created by Paul Kraft on 21.04.22.
//

import SwiftUI

struct NewGridPopover: View {

    // MARK: Stored Properties

    @Binding var grids: [MapGrid]

    @State private var grid = MapGrid()
    @Environment(\.self) private var environment

    // MARK: Computed Properties

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                NumberField(title: "North", value: $grid.northLatitude)
                NumberField(title: "West", value: $grid.westLongitude)
                NumberField(title: "South", value: $grid.southLatitude)
                NumberField(title: "East", value: $grid.eastLongitude)

                Stepper(value: $grid.latitudinalCount, in: 1...200) {
                    HStack {
                        Text("Rows (Latitude)")
                        Spacer()
                        Text(grid.latitudinalCount.description)
                    }
                }

                Stepper(value: $grid.longitudinalCount, in: 1...200) {
                    HStack {
                        Text("Columns (Longitude)")
                        Spacer()
                        Text(grid.longitudinalCount.description)
                    }
                }

                Stepper(value: $grid.overlap, in: 0...50) {
                    HStack {
                        Text("Overlap")
                        Spacer()
                        Text("\(grid.overlap) %")
                    }
                }

                ColorPicker("Inner Color", selection: $grid.innerColor)
                ColorPicker("Outer Color", selection: $grid.outerColor)

                Button("Add") {
                    grids.append(grid)
                    environment.dismiss()
                }
            }
            #if !os(macOS)
            .frame(minWidth: UIScreen.main.bounds.width / 4)
            #endif
            .padding(24)
        }
    }

}
