//
//  LocalShortcutManager.swift
//  QuickSniper
//
//  Created by 이민호 on 6/13/25.
//

import Foundation
import Combine
import AppKit

final class LocalShortcutService: FolderSubjectBindable {
    let snippetSubject: CurrentValueSubject<SnippetMessage?, Never>
    let serviceSubject: CurrentValueSubject<ServiceMessage?, Never>
    let selectedFolderSubject: CurrentValueSubject<Folder?, Never>
    var cancellables: Set<AnyCancellable> = []
    var shorcutStorage = LocalShortcutStorage()
    var snippet: Snippet?
    var selectedFolder: Folder?
        
    init(
        snippetSubject: CurrentValueSubject<SnippetMessage?, Never>,
        serviceSubject: CurrentValueSubject<ServiceMessage?, Never>,
        selectedFolderSubject: CurrentValueSubject<Folder?, Never>
    ) {
        self.snippetSubject = snippetSubject
        self.serviceSubject = serviceSubject
        self.selectedFolderSubject = selectedFolderSubject
        
        setUpSelectedSnippet()
        setupServiceMessage()
        setupSelectedFolderBindings()
    }
                    
    func handleKeyEvent(_ event: NSEvent) {        
        for shortcut in shorcutStorage.shortcuts {
            if shortcut.matches(event) {
                executeAction(shortcut.action)
                break
            }
        }
    }
}

extension LocalShortcutService {
    private func executeAction(_ action: LocalShortcut.ShortcutAction) {
        switch action {
        case .copySnippet:
            handleCopyCommand()
        }
    }
    
    private func handleCopyCommand() {
        guard let snippet = snippet else {
            return
        }
        serviceSubject.send(.copySnippet(snippet))
    }
}

extension LocalShortcutService {
    private func setupSelectedFolderBindings() {
        selectedFolderSubject
            .sink { [weak self] folder in
                self?.selectedFolder = folder
                self?.snippet = nil
            }
            .store(in: &cancellables)
    }
    
    private func setUpSelectedSnippet() {
        snippetSubject
            .sink { [weak self] message in
                switch message {
                case .snippetSelected(let snippet):
                    self?.snippet = snippet
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupServiceMessage() {
        serviceSubject
            .sink { [weak self] message in
                switch message {
                case .handleKeyEvent(let event):
                    self?.handleKeyEvent(event)
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
}
