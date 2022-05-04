//
//  ReaderOptionsPopover.swift
//  AISVisualizer
//
//  Created by Paul Kraft on 21.04.22.
//

import SwiftUI

struct ReaderOptionsPopover: View {

    // MARK: Static Properties

    static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter
    }()

    // MARK: Stored Properties

    @Binding var options: ReaderOptions

    // MARK: Computed Properties

    var body: some View {
        Popover {
            Toggle(
                "Line Limit",
                isOn: .init {
                    options.lineLimit != .max
                } set: { isOn in
                    options.lineLimit = isOn ? Constants.lineLimitRange.upperBound : .max
                }
            )
            if options.lineLimit != .max {
                Text(
                    Self.formatter.string(from: options.lineLimit as NSNumber)
                        ?? options.lineLimit.description
                )
                Slider(
                    value: Binding<Double> {
                        Double(options.lineLimit)
                    } set: {
                        options.lineLimit = Int($0 / Double(Constants.lineLimitStep)) * Constants.lineLimitStep
                    },
                    in: Double(Constants.lineLimitRange.lowerBound)...Double(Constants.lineLimitRange.upperBound)
                )
            }
        }
    }

}
