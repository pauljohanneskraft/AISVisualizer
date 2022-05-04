//
//  Popover.swift
//  AISVisualizer
//
//  Created by Paul Kraft on 04.05.22.
//

import SwiftUI

struct Popover<Content: View>: View {

    // MARK: Stored Properties

    @ViewBuilder var content: () -> Content
    @Environment(\.self) private var environment

    // MARK: Computed Properties

    var body: some View {
        #if os(macOS)
        scrollViewContent
        #else
        if UIDevice.current.userInterfaceIdiom == .phone {
            NavigationView {
                ScrollView {
                    scrollViewContent
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Close") {
                            environment.dismiss()
                        }
                    }
                }
            }
            .navigationViewStyle(.stack)
        } else {
            ScrollView {
                scrollViewContent
            }
        }
        #endif
    }

    private var scrollViewContent: some View {
        VStack(spacing: 24) {
            content()
        }
        .padding(24)
        .frame(minWidth: 350)
    }

}
