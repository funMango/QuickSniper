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

final class SnippetEditorController: ViewWindowControllable {
    @Injected var viewModelContainer: ViewModelContainer
    let subject: PassthroughSubject<ControllerMessage, Never>
    let hideMessage: ControllerMessage = .hideSnippetEditorView
    var windowController: BasePanelController<SnippetEditorView>?
    var cancellables = Set<AnyCancellable>()
    var width: CGFloat = 450, height: CGFloat = 600
    var isVisible: Bool = false
    private var snippet: Snippet?
    
    init(
        subject: PassthroughSubject<ControllerMessage, Never>
    ) {
        self.subject = subject
        setupBindings()
        controllMessageBindings()        
    }

    func makeView() -> SnippetEditorView {
        return SnippetEditorView(
            viewModel: viewModelContainer.getSnippetEditorViewModel(snippet: snippet),
            width: width,
            height: height
        )
    }

    func show() {
        if let snippet = snippet {
            makeWindowController(
                size: CGSize(width: width, height: height),
                page: .snippetEditorWith(snippet)
            )
        } else {
            makeWindowController(
                size: CGSize(width: width, height: height),
                page: .snippetEditor
            )
        }
    }
    
    func controllMessageBindings() {
        subject
            .sink { [weak self] message in
                guard let self else { return }
                
                switch message {
                case .showSnippetEditorWith(let snippet):
                    self.snippet = snippet
                    show()
                    self.snippet = nil
                case .showSnipperEditor:
                    show()
                    
                default: break
                }
            }
            .store(in: &cancellables)
    }
}
