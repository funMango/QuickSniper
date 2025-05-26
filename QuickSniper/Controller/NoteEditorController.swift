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

final class NoteEditorController {
    @Injected var viewModelContainer: ViewModelContainer
    private let subject: PassthroughSubject<ControllerMessage, Never>
    private var windowController: BaseWindowController<NoteEditorView>?
    private var cancellables = Set<AnyCancellable>()

    init(subject: PassthroughSubject<ControllerMessage, Never>) {
        self.subject = subject
        setupBindings()
    }

    func show() {
        Resolver.resolve(ControllerContainer.self).panelController.hidePanel()
        
        if windowController == nil {
            windowController = BaseWindowController(size: CGSize(width: 600, height: 500)) {
                NoteEditorView(viewModel: self.viewModelContainer.noteEditorViewModel)
            }
        }
        windowController?.show()
    }
    
    private func hide() {
        windowController?.close()
        windowController = nil
        subject.send(.togglePanel)
    }
    
    private func setupBindings() {
        subject
            .sink { [weak self] message in
                if message == .hideNoteEditorView {
                    self?.hide()
                }
            }
            .store(in: &cancellables)
    }
}
