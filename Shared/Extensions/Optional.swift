//
//  Optional.swift
//  AISVisualizer
//
//  Created by Paul Kraft on 21.04.22.
//

import Foundation

extension Optional where Wrapped: Comparable {

    mutating func formMinimum(_ other: Self) {
        self = flatMap { this in other.flatMap { Swift.min($0, this) } ?? this } ?? other
    }

    mutating func formMaximum(_ other: Self) {
        self = flatMap { this in other.flatMap { Swift.max($0, this) } ?? this } ?? other
    }

}
