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
    @State private var error: String?
    @Environment(\.self) private var environment

    // MARK: Computed Properties

    var body: some View {
        Popover {

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

            ColorPicker(selection: $grid.innerColor) {
                HStack {
                    Text("Inner Color")
                    Spacer()
                }
            }

            ColorPicker(selection: $grid.outerColor) {
                HStack {
                    Text("Outer Color")
                    Spacer()
                }
            }

            Button("Add") {
                if let error = grid.validate() {
                    self.error = error
                    return
                }
                grids.append(grid)
                environment.dismiss()
            }

        }
        .alert(item: $error) { error in
            Alert(
                title: Text("Error"),
                message: Text(error)
            )
        }
    }

}
