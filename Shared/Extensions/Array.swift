//
//  Array.swift
//  AISVisualizer
//
//  Created by Paul Kraft on 21.04.22.
//

import Foundation

extension Array {

    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }

}
