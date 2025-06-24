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
    private let hotCornerSubject: CurrentValueSubject<HotCornerMessage?, Never>
    private var cancellables = Set<AnyCancellable>()
    
    private var snippetEditorController: SnippetEditorController?
    private var shortcutSettingsController: SettingsController?
    private var createFolderController: FolderCreateController?
    private var panelController: PanelController?
    private var hotCornerController: HotCornerController?
    private var toastController: ToastController?
    private var fileBookmakrController: FileBookmarkController?
    
    private var panelStatus = false
                
    init(
        controllSubject: PassthroughSubject<ControllerMessage, Never>,
        hotCornerSubject: CurrentValueSubject<HotCornerMessage?, Never>,
    ) {
        self.controllSubject = controllSubject
        self.hotCornerSubject = hotCornerSubject        
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
                case .togglePanel:
                    togglePanel()
                case .openPanel:
                    switchCurrentPage(.panel)
                case .openSnippetEditorWith(let snippet):
                    switchCurrentPage(.snippetEditorWith(snippet))
                case .openSnippetEditor:
                    switchCurrentPage(.snippetEditor)
                case .openShortcutSettingView:
                    switchWindow(.shortcutSettings)
                case .openCreateFolderView:
                    switchCurrentPage(.createFolder)
                case .openFileBookmarkCreateView:
                    switchCurrentPage(.fileBookmark)
                case .openHotCorner:
                    hotConerConrollerInit()
                    DispatchQueue.main.async { [weak self] in
                        self?.hotCornerController?.show()
                    }
                case .openToast(let title):
                    toastControllerInit()
                    DispatchQueue.main.async { [weak self] in
                        self?.controllSubject.send(.showToast(title))
                    }
                case .panelStatus(let status):
                    self.panelStatus = status
                
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Controller init
extension ControllerContainer {
    private func togglePanel() {
        if !panelStatus {
            switchCurrentPage(.panel)
        } else {
            controllSubject.send(.allPageClose)
        }
    }
    
    private func switchWindow(_ window: Window) {
        switch window {
        case .shortcutSettings:
            shortcutSettingsControllerInit()
        }
            
        DispatchQueue.main.async { [weak self] in
            self?.controllSubject.send(window.getShowMessage())
        }
    }
    
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
        case .fileBookmark:
            fileBookmarkControllerInit()
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
            self.shortcutSettingsController = SettingsController(
                subject: controllSubject
            )
        }
    }
    
    private func createFolderControllerInit() {
        if createFolderController == nil {
            self.createFolderController = FolderCreateController(
                subject: controllSubject
            )
        }
    }
    
    private func fileBookmarkControllerInit() {
        if fileBookmakrController == nil {
            self.fileBookmakrController = FileBookmarkController(
                subject: controllSubject
            )
        }
    }
    
    private func hotConerConrollerInit() {
        if hotCornerController == nil {
            self.hotCornerController = HotCornerController(
                controllSubject: controllSubject,
                hotCornerSubject: hotCornerSubject
            )
        }
    }
    
    private func toastControllerInit() {
        if toastController == nil {
            self.toastController = ToastController(
                controllSubject: controllSubject
            )
        }
    }
}
