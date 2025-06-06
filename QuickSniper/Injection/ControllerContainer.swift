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
    
    lazy var panelController = PanelController(subject: controllSubject)
}

extension ControllerContainer {
    private func controllMesaageBindings() {
        controllSubject
            .sink { [weak self] message in
                guard let self else { return }
                
                switch message {
                case .openSnippetEditorWith(let snippet):
                    switchCurrentPage(.snippetEditorWith(snippet))
                case .openSnippetEditor:
                    switchCurrentPage(.snippetEditor)
                case .openShortcutSettingView:
                    switchCurrentPage(.shortcutSettings)
                case .openCreateFolderView:
                    switchCurrentPage(.createFolder)
                case .escapePressed:
                    closePage()
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
}

extension ControllerContainer {
    private func closePage() {
        if let currentPage = currentPage {
            controllSubject.send(currentPage.getHideMessage())
            self.currentPage = nil
        } else {
            controllSubject.send(.closePanel)
        }
    }
    
    private func switchCurrentPage(_ page: Page) {
        if let currentPage = currentPage {
            self.controllSubject.send(currentPage.getHideMessage())
        }
        
        switch page {
        case .snippetEditor:
            snippetEditorControllerInit()
        case .snippetEditorWith(let snippet):
            snippetEditorControllerInit(snippet)
        case .shortcutSettings:
            shortcutSettingsControllerInit()
        case .createFolder:
            createFolderControllerInit()
        }
        
        self.currentPage = page
        DispatchQueue.main.async { [weak self] in
            self?.controllSubject.send(page.getShowMessage())
        }
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
    
    private func createFolderControllerInit() {
        if createFolderController == nil {
            self.createFolderController = CreateFolderController(
                subject: controllSubject
            )
        }
    }
}
