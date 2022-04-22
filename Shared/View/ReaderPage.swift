//
//  LoadingPage.swift
//  AISVisualizer
//
//  Created by Paul Kraft on 21.02.22.
//

import SwiftUI

@MainActor
struct ReaderPage: View {

    // MARK: Stored Properties

    @StateObject var model: ReaderModel

    @State private var urls = [URL]()
    @State private var showsDocumentPicker = false
    @State private var showsOptionsPopover = false

    // MARK: Computed Properties

    var body: some View {
        switch model.state {
        case .ready:
            Group {
                if urls.isEmpty {
                    Text("No AIS files selected.")
                    Text("Please make sure to select AIS files to be able to add ship paths.")
                } else {
                    List {
                        ForEach(urls, id: \.absoluteString) { url in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(url.lastPathComponent)
                                    Text(url.deletingLastPathComponent().lastPathComponent)
                                        .opacity(0.5)
                                }

                                Spacer()

                                Button("Delete") {
                                    urls.removeAll { $0.absoluteString == url.absoluteString }
                                }
                                .foregroundColor(.red)
                            }
                        }
                        .onDelete { urls.remove(atOffsets: $0) }
                    }
                }
            }
            .navigationTitle("\(urls.count) file(s) selected")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    HStack {
                        DocumentPicker(contentTypes: [.commaSeparatedText], urls: $urls) {
                            Text("Add")
                        }

                        Button("Options") {
                            showsOptionsPopover = true
                        }
                        .popover(isPresented: $showsOptionsPopover) {
                            ReaderOptionsPopover(options: $model.options)
                        }

                        Button("Continue") {
                            model.read(urls: urls)
                        }
                    }
                }
            }
        case let .loading(rowCount):
            VStack(spacing: 24) {
                ProgressView()
                Text(rowCount.formatted())
                Button("Cancel") {
                    model.reset()
                }
            }
        case let .finished(map):
            VisualizationPage(model: model, map: map)
        }
    }

}
