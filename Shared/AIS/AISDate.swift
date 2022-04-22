//
//  AISDate.swift
//  AISVisualizer
//
//  Created by Paul Kraft on 03.02.22.
//

import Foundation

private let _calendar = Calendar(identifier: .gregorian)
private let _timeZone = TimeZone(secondsFromGMT: 0)

struct AISDate: Hashable {

    // MARK: Stored Properties

    let year: Int
    let month: Int
    let day: Int
    let hour: Int
    let minute: Int
    let second: Double

    // MARK: Computed Properties

    var actualDate: Date? {
        let components = DateComponents(
            calendar: _calendar,
            timeZone: _timeZone,
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            second: Int(second)
        )

        return components.date
    }

}

// MARK: - Comparable

extension AISDate: Comparable {

    static func < (lhs: AISDate, rhs: AISDate) -> Bool {
        guard lhs.year == rhs.year else {
            return lhs.year < rhs.year
        }

        guard lhs.month == rhs.month else {
            return lhs.month < rhs.month
        }

        guard lhs.day == rhs.day else {
            return lhs.day < rhs.day
        }

        guard lhs.hour == rhs.hour else {
            return lhs.hour < rhs.hour
        }

        guard lhs.minute == rhs.minute else {
            return lhs.minute < rhs.minute
        }

        return lhs.second < rhs.second
    }

}
