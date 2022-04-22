//
//  AISVisualizerApp.swift
//  Shared
//
//  Created by Paul Kraft on 21.02.22.
//

import SwiftUI

@main
struct AISVisualizerApp: App {

    // MARK: Computed Properties

    var body: some Scene {
        #if os(macOS)
        WindowGroup {
            NavigationView {
                EmptyView()
                ReaderPage(model: ReaderModel())
            }
        }
        .commands {
            SidebarCommands()
        }
        #else
        WindowGroup {
            NavigationView {
                ReaderPage(model: ReaderModel())
                    .navigationBarTitleDisplayMode(.inline)
            }
            .navigationViewStyle(.stack)
        }
        #endif
    }

}
