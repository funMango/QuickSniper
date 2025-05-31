//
//  ControllerContainer.swift
//  QuickSniper
//
//  Created by 이민호 on 5/22/25.
//

import AppKit
import SwiftUI
import Combine
import Resolver

final class NoteEditorController: ViewWindowControllable {
    @Injected var viewModelContainer: ViewModelContainer

    let subject: PassthroughSubject<ControllerMessage, Never>
    let hideMessage: ControllerMessage = .hideNoteEditorView
    var windowController: BaseWindowController<SnippetEditorView>?
    var cancellables = Set<AnyCancellable>()
    var width: CGFloat = 450, height: CGFloat = 600

    init(subject: PassthroughSubject<ControllerMessage, Never>) {
        self.subject = subject
        setupBindings()
    }

    func makeView() -> SnippetEditorView {
        SnippetEditorView(
            viewModel: viewModelContainer.noteEditorViewModel,
            width: width,
            height: height
        )
    }

    func show() {
        makeWindowController(size: CGSize(width: width, height: height))
    }
}
