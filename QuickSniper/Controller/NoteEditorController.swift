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
    var windowController: BaseWindowController<NoteEditorView>?
    var cancellables = Set<AnyCancellable>()

    init(subject: PassthroughSubject<ControllerMessage, Never>) {
        self.subject = subject
        setupBindings()
    }

    func makeView() -> NoteEditorView {
        NoteEditorView(viewModel: viewModelContainer.noteEditorViewModel)
    }

    func show() {
        makeWindowController()
    }
}
