//
//  ServiceContainer.swift
//  QuickSniper
//
//  Created by 이민호 on 6/10/25.
//

import Foundation
import Combine
import AppKit

final class ServiceContainer {
    private let serviceSubject: CurrentValueSubject<ServiceMessage?, Never>
    private let controllSubject: PassthroughSubject<ControllerMessage, Never>
    private let snippetSubject: CurrentValueSubject<SnippetMessage?, Never>
    private let selectedFolderSubject: CurrentValueSubject<Folder?, Never>
    private var cancellables = Set<AnyCancellable>()
    
    private var clipboardService: ClipboardService?
    private var localShortcutService: LocalShortcutService?
    
    init(
        serviceSubject: CurrentValueSubject<ServiceMessage?, Never>,
        controllSubject: PassthroughSubject<ControllerMessage, Never>,
        snippetSubject: CurrentValueSubject<SnippetMessage?, Never>,
        selectedFolderSubject: CurrentValueSubject<Folder?, Never>
    ) {
        self.serviceSubject = serviceSubject
        self.controllSubject = controllSubject
        self.snippetSubject = snippetSubject
        self.selectedFolderSubject = selectedFolderSubject
        
        serviceMessageBindings()
        setupSnippetMessageBindings()
    }
}

extension ServiceContainer {
    private func serviceMessageBindings() {
        serviceSubject
            .sink { [weak self] message in
                guard let self else { return }
                
                switch message {
                case .copySnippet(let snippet):
                    clipboardServiceInit()
                    DispatchQueue.main.async{ [weak self] in
                        self?.serviceSubject.send(.copySnippetBody(snippet))
                    }
                case .pressShortcut(let event):
                    localShortcutServiceInit()
                    DispatchQueue.main.async{ [weak self] in
                        self?.serviceSubject.send(.handleKeyEvent(event))
                    }
                default:
                    return
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupSnippetMessageBindings() {
        snippetSubject
            .sink { [weak self] message in
                guard let self else { return }
                
                switch message {
                case .snippetSelected(let snippet):
                    if localShortcutService == nil {
                        localShortcutServiceInit()
                        DispatchQueue.main.async{ [weak self] in
                            self?.snippetSubject.send(.snippetSelected(snippet))
                        }
                    }
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
}

extension ServiceContainer {
    private func clipboardServiceInit() {
        if clipboardService == nil {
            self.clipboardService = ClipboardService(
                serviceSubject: serviceSubject,
                controllSubject: controllSubject
            )
        }
    }
    
    private func localShortcutServiceInit() {
        if localShortcutService == nil {
            self.localShortcutService = LocalShortcutService(
                snippetSubject: snippetSubject,
                serviceSubject: serviceSubject,
                selectedFolderSubject: selectedFolderSubject
            )
        }
    }
}
