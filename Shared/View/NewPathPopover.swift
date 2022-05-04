//
//  NewPathPopover.swift
//  AISVisualizer
//
//  Created by Paul Kraft on 21.04.22.
//

import SwiftUI

struct NewPathPopover: View {

    // MARK: Stored Properties

    let map: AISMap
    @Binding var paths: [ShipPath]

    @State private var mmsi = String()
    @State private var start = Date()
    @State private var end = Date()
    @State private var color = Color.black
    @State private var interpolate = false
    @State private var interpolationInterval = 10.0
    @State private var error: String?
    @State private var isLoading = false

    @Environment(\.self) private var environment

    // MARK: Computed Properties

    var body: some View {
        Popover {
            if isLoading {
                ProgressView()
            } else {

                TextField("MMSI", text: $mmsi)
                #if !os(macOS)
                    .keyboardType(.numberPad)
                #endif

                Toggle(isOn: $interpolate) {
                    HStack {
                        Text("Interpolation\(interpolate ? ": " + formattedInterpolationInterval : String())")
                        Spacer()
                    }
                }

                if interpolate {
                    Slider(value: $interpolationInterval, in: 1...(20 * 60))
                }

                DatePicker(selection: $start) {
                    HStack {
                        Text("Start")
                        Spacer()
                    }
                }

                DatePicker(selection: $end) {
                    HStack {
                        Text("End")
                        Spacer()
                    }
                }

                ColorPicker(selection: $color) {
                    HStack {
                        Text("Color")
                        Spacer()
                    }
                }

                Button("Add") {
                    Task {
                        isLoading = true
                        guard let mmsi = Int(mmsi) else {
                            error = "MMSI is not a number."
                            isLoading = false
                            return
                        }
                        if let path = await map.path(
                            mmsi: mmsi,
                            start: start,
                            interval: interpolate ? interpolationInterval : nil,
                            end: end,
                            color: color
                        ) {
                            paths.append(path)
                            environment.dismiss()
                        } else {
                            error = "MMSI unknown or ship not present in given interval."
                        }
                        isLoading = false
                    }
                }

            }
        }
        .alert(item: $error) { error in
            Alert(
                title: Text("Error"),
                message: Text(error)
            )
        }
        .task {
            let range = await map.dateRange
            self.start = range?.start.actualDate ?? Date()
            self.end = range?.end.actualDate ?? Date()
        }
        .environment(\.timeZone, TimeZone(secondsFromGMT: 0)!)
    }

    private var formattedInterpolationInterval: String {
        (Date(timeIntervalSince1970: 0)..<Date(timeIntervalSince1970: interpolationInterval))
            .formatted(.components(style: .condensedAbbreviated, fields: [.minute, .second]))
    }

}
