//
//  Range.swift
//  AISVisualizer
//
//  Created by Paul Kraft on 22.04.22.
//

import Foundation

extension ClosedRange {

    func clamp(_ value: Bound) -> Bound {
        Swift.min(Swift.max(lowerBound, value), upperBound)
    }

}
