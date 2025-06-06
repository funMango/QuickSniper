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
    private var snippetEditorController: SnippetEditorController?
    private var shortcutSettingsController: ShortcutSettingsController?
    private var cancellables = Set<AnyCancellable>()
                
    init(
        controllSubject: PassthroughSubject<ControllerMessage, Never>,
        geometrySubject: CurrentValueSubject<CGRect, Never>,
    ) {
        self.controllSubject = controllSubject
        self.geometrySubject = geometrySubject
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
                    DispatchQueue.main.async { [weak self] in
                        self?.controllSubject.send(.showSnippetEditorWith(snippet))
                    }
                case .openSnippetEditor:
                    snippetEditorControllerInit()
                    DispatchQueue.main.async { [weak self] in
                        self?.controllSubject.send(.showSnipperEditor)
                    }
                case .openShortcutSettingView:
                    shortcutSettingsControllerInit()
                    DispatchQueue.main.async { [weak self] in
                        self?.controllSubject.send(.showShortcutSettingView)
                    }
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    private func snippetEditorControllerInit(_ snippet: Snippet? = nil) {
        if snippetEditorController == nil {
            self.snippetEditorController = SnippetEditorController(
                subject: controllSubject
            )
        }
    }
    
    private func shortcutSettingsControllerInit() {
        if shortcutSettingsController == nil {
            self.shortcutSettingsController = ShortcutSettingsController(
                subject: controllSubject
            )
        }
    }
}
