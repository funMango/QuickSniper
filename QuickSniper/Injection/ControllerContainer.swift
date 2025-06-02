//
//  ControllerContainer.swift
//  QuickSniper
//
//  Created by 이민호 on 5/22/25.
//

import Foundation
import Combine

final class ControllerContainer {
    private let controllSubject: PassthroughSubject<ControllerMessage, Never>
    private let geometrySubject: CurrentValueSubject<CGRect, Never>
    private let snippetSubject: PassthroughSubject<Snippet?, Never>
    private var snippetEditorController: SnippetEditorController?
    private var cancellables = Set<AnyCancellable>()
                
    init(
        controllSubject: PassthroughSubject<ControllerMessage, Never>,
        geometrySubject: CurrentValueSubject<CGRect, Never>,
        snippetSubject: PassthroughSubject<Snippet?, Never>
    ) {
        self.controllSubject = controllSubject
        self.geometrySubject = geometrySubject
        self.snippetSubject = snippetSubject
        controllMesaageBindings()
    }
    
    lazy var panelController = PanelController(subject: controllSubject)
    lazy var createFolderController = CreateFolderController(subject: controllSubject)
}

extension ControllerContainer {
    private func controllMesaageBindings() {
        controllSubject
            .sink { [weak self] message in
                guard let self else { return }
                
                switch message {
                case .openSnippetEditorWith(let snippet):
                    snippetEditorControllerInit(snippet)
                case .openSnippetEditor:
                    snippetEditorControllerInit()
                case .snippetEditorControllerInitWith(let snippet):
                    controllSubject.send(.showSnippetEditorWith(snippet))
                case .snippetEditorControllerInit:
                    controllSubject.send(.showSnipperEditor)
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    private func snippetEditorControllerInit(_ snippet: Snippet? = nil) {
        self.snippetEditorController = SnippetEditorController(
            subject: controllSubject
        )
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            if let snippet = snippet {
                self.controllSubject.send(.snippetEditorControllerInitWith(snippet))
            } else {
                self.controllSubject.send(.snippetEditorControllerInit)
            }
        }
    }
}
