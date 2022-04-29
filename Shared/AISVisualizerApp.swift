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
                Button("Hide sidebar") {
                    NSApp.sendAction(#selector(NSSplitViewController.toggleSidebar(_:)), to: nil, from: nil)
                }
                ReaderPage(model: ReaderModel())
            }
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
