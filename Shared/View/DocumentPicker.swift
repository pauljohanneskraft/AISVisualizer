//
//  DocumentPage.swift
//  AISVisualizer
//
//  Created by Paul Kraft on 21.02.22.
//

import SwiftUI
import UniformTypeIdentifiers

#if canImport(UIKit) || canImport(AppKit)

struct DocumentPicker<Label: View>: View {

    // MARK: Stored Properties

    let contentTypes: [UTType]
    @Binding var urls: [URL]
    @ViewBuilder var label: () -> Label

    #if canImport(UIKit)
    @State private var showsSheet = false
    #endif

    // MARK: Computed Properties

    var body: some View {
        #if canImport(AppKit)
        Button {
            open()
        } label: {
            label()
        }
        #else
        Button {
            showsSheet = true
        } label: {
            label()
        }
        .sheet(isPresented: $showsSheet) {
            _DocumentPickerSheet(contentTypes: contentTypes, urls: $urls)
        }
        #endif
    }

}

extension RangeReplaceableCollection {

    fileprivate mutating func appendUniquely<S: Sequence>(
        contentsOf sequence: S, equals: (Element, Element) throws -> Bool
    ) rethrows where S.Element == Element {
        let newItems = try sequence.filter { item in
            try !contains { try equals(item, $0) }
        }
        append(contentsOf: newItems)
    }

}

#endif

#if canImport(UIKit)

import UIKit

fileprivate struct _DocumentPickerSheet {

    // MARK: Stored Properties

    let contentTypes: [UTType]
    @Binding var urls: [URL]

}

extension _DocumentPickerSheet {

    // MARK: Nested Types

    class Coordinator: NSObject {

        // MARK: Stored Properties

        let view: _DocumentPickerSheet

        // MARK: Initialization

        init(view: _DocumentPickerSheet) {
            self.view = view
        }

    }

    // MARK: Methods

    func makeCoordinator() -> Coordinator {
        Coordinator(view: self)
    }

}

// MARK: - UIViewControllerRepresentable

extension _DocumentPickerSheet: UIViewControllerRepresentable {

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let controller = UIDocumentPickerViewController(forOpeningContentTypes: contentTypes)
        updateUIViewController(controller, context: context)
        return controller
    }

    func updateUIViewController(_ controller: UIDocumentPickerViewController, context: Context) {
        controller.delegate = context.coordinator
    }

}

// MARK: - UIDocumentPickerDelegate

extension _DocumentPickerSheet.Coordinator: UIDocumentPickerDelegate {

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        view.urls.appendUniquely(contentsOf: urls) { $0.absoluteString == $1.absoluteString }
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {

    }

}

#elseif canImport(AppKit)

import AppKit

extension DocumentPicker {

    private func open() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = contentTypes
        if panel.runModal() == .OK {
            urls.appendUniquely(contentsOf: panel.urls) { $0.absoluteString == $1.absoluteString }
        }
    }

}

#endif
