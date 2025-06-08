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
    private var createFolderController: CreateFolderController?
    private var panelController: PanelController?
    private var cancellables = Set<AnyCancellable>()
    private var currentPage: Page?
                
    init(
        controllSubject: PassthroughSubject<ControllerMessage, Never>,
        geometrySubject: CurrentValueSubject<CGRect, Never>,
    ) {
        self.controllSubject = controllSubject
        self.geometrySubject = geometrySubject
        controllMesaageBindings()
    }
}

// MARK: - Controll Message Binding
extension ControllerContainer {
    private func controllMesaageBindings() {
        controllSubject
            .sink { [weak self] message in
                guard let self else { return }
                
                switch message {
                case .openPanel:
                    switchCurrentPage(.panel)
                case .openSnippetEditorWith(let snippet):
                    switchCurrentPage(.snippetEditorWith(snippet))
                case .openSnippetEditor:
                    switchCurrentPage(.snippetEditor)
                case .openShortcutSettingView:
                    switchCurrentPage(.shortcutSettings)
                case .openCreateFolderView:
                    switchCurrentPage(.createFolder)
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Controller init
extension ControllerContainer {
    private func switchCurrentPage(_ page: Page) {
        switch page {
        case .panel:
            panelControllerInit()
        case .snippetEditor:
            snippetEditorControllerInit()
        case .snippetEditorWith(_):
            snippetEditorControllerInit()
        case .shortcutSettings:
            shortcutSettingsControllerInit()
        case .createFolder:
            createFolderControllerInit()
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.controllSubject.send(.switchPage(page))
        }
    }
    
    private func panelControllerInit() {
        if panelController == nil {
            self.panelController = PanelController(
                subject: controllSubject
            )
        }
    }
    
    private func snippetEditorControllerInit() {
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
    
    private func createFolderControllerInit() {
        if createFolderController == nil {
            self.createFolderController = CreateFolderController(
                subject: controllSubject
            )
        }
    }
}
