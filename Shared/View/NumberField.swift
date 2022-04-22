//
//  NumberField.swift
//  AISVisualizer
//
//  Created by Paul Kraft on 22.04.22.
//

import SwiftUI

struct NumberField: View {

    // MARK: Stored Properties

    let title: String
    @Binding var value: Double

    // MARK: Computed Properties

    var body: some View {
        Label {
            TextField(title, value: $value, format: .number)
                .contentShape(Rectangle())
            #if !os(macOS)
                .keyboardType(.numberPad)
            #endif
                .multilineTextAlignment(.trailing)
        } icon: {
            Text(title)
        }
    }

}
