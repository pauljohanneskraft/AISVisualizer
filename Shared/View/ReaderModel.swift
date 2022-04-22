//
//  ReaderModel.swift
//  AISVisualizer
//
//  Created by Paul Kraft on 21.04.22.
//

import Foundation

@MainActor
class ReaderModel: ObservableObject {

    // MARK: Nested Types

    enum State {
        case ready
        case loading(rowCount: Int)
        case finished(Map)
    }

    // MARK: Stored Properties

    @Published var options = ReaderOptions()
    @Published var state = State.ready
    @Published var error: String?

    private var task: Task<Void, Never>?

    // MARK: Methods

    func read(urls: [URL]) {
        let map: Map

        switch state {
        case .ready:
            map = Map()
        case .loading:
            return
        case let .finished(currentMap):
            map = currentMap
        }

        guard !urls.isEmpty else {
            state = .finished(map)
            return
        }

        task = Task {
            do {
                state = .loading(rowCount: 0)
                var newCount = 0
                for url in urls {
                    guard url.startAccessingSecurityScopedResource() else {
                        throw URLError(.noPermissionsToReadFile)
                    }

                    for try await row in url.lines.dropFirst().prefix(options.lineLimit).map(AISRow.from) {
                        await map.read(ais: row)
                        newCount += 1

                        if newCount % 10_000 == 0 {
                            state = .loading(rowCount: newCount)
                        }
                    }

                    state = .loading(rowCount: newCount)
                    url.stopAccessingSecurityScopedResource()
                }
                state = .finished(map)
            } catch let newError {
                error = newError.localizedDescription
                state = .ready
            }
        }
    }

    func reset() {
        task?.cancel()
        state = .ready
    }

}
