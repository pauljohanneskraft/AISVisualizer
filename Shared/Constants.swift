//
//  Constants.swift
//  AISVisualizer
//
//  Created by Paul Kraft on 06.02.22.
//

import Foundation
import SwiftUI

enum Constants {

    // MARK: Static Properties

    static let lineLimitRange = 10_000...20_000_000
    static let lineLimitStep = 10_000
    static let defaultLineLimit = Int.max

    static let defaultPolylineStrokeColor = Color.black
    static let defaultPolygonFillColor = Color.red.opacity(0.3)
    static let minimumCoordinateTimeDifference = 0.01 // seconds

}
