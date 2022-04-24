//
//  NewPathPopover.swift
//  AISVisualizer
//
//  Created by Paul Kraft on 21.04.22.
//

import SwiftUI

struct NewPathPopover: View {

    // MARK: Stored Properties

    let map: Map
    @Binding var paths: [ShipPath]

    @State private var mmsi = String()
    @State private var start = Date()
    @State private var end = Date()
    @State private var color = Color.black
    @State private var error: String?
    @State private var isLoading = false

    @Environment(\.self) private var environment

    // MARK: Computed Properties

    var body: some View {
        VStack(spacing: 24) {
            TextField("MMSI", text: $mmsi)
            #if !os(macOS)
                .keyboardType(.numberPad)
            #endif
            DatePicker("Start", selection: $start)
            DatePicker("End", selection: $end)
            ColorPicker("Color", selection: $color)
            if isLoading {
                ProgressView()
            } else {
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
                            interval: nil,
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
        .padding(24)
    }

}
