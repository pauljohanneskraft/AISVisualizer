//
//  AISRow.swift
//  AISVisualizer
//
//  Created by Paul Kraft on 03.02.22.
//

import Foundation

/// MMSI,BaseDateTime,LAT,LON,SOG,COG,Heading,VesselName,IMO,CallSign,VesselType,Status,Length,Width,Draft,Cargo,TranscieverClass
struct AISRow {

    // MARK: Static Functions

    static func from(line: String) throws -> AISRow {
        let items = line.split(separator: ",", omittingEmptySubsequences: false)
        guard items.count >= 4 else {
            assertionFailure("Row \"\(items)\" does not contain at least 4 items")
            throw NSError()
        }

        guard let mmsi = Int(items[0]),
              let date = Self.date(from: items[1]),
              let latitude = Double(items[2]),
              let longitude = Double(items[3]) else {
            assertionFailure("Missing fields in row: \"\(items)\"")
            throw NSError()
        }

        return AISRow(
            mmsi: mmsi,
            date: date,
            latitude: latitude,
            longitude: longitude,
            vesselName: items[safe: 7].map(String.init) ?? String(),
            vesselType: items[safe: 10].flatMap { Int($0) },
            length: items[safe: 12].flatMap(Double.init),
            width: items[safe: 13].flatMap(Double.init),
            draft: items[safe: 14].flatMap(Double.init),
            cargo: items[safe: 15].flatMap(Double.init)
        )
    }

    private static func date(from string: Substring) -> AISDate? {
        guard string.count == 19 else {
            return nil
        }
        
        let startIndex = string.startIndex
        guard let year = Int(string[startIndex..<string.index(startIndex, offsetBy: 4)]),
              let month = Int(string[string.index(startIndex, offsetBy: 5)..<string.index(startIndex, offsetBy: 7)]),
              let day = Int(string[string.index(startIndex, offsetBy: 8)..<string.index(startIndex, offsetBy: 10)]),
              let hour = Int(string[string.index(startIndex, offsetBy: 11)..<string.index(startIndex, offsetBy: 13)]),
              let minute = Int(string[string.index(startIndex, offsetBy: 14)..<string.index(startIndex, offsetBy: 16)]),
              let second = Double(string[string.index(startIndex, offsetBy: 17)...]) else {
            return nil
        }

        return AISDate(year: year, month: month, day: day, hour: hour, minute: minute, second: second)
    }

    // MARK: Stored Properties

    let mmsi: Int
    let date: AISDate
    let latitude: Double
    let longitude: Double
    let vesselName: String
    let vesselType: Int?
    let length: Double?
    let width: Double?
    let draft: Double?
    let cargo: Double?

}
