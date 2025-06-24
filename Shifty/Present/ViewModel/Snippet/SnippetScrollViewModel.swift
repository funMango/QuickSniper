//
//  SnippetScrollViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 5/30/25.
//

import Foundation
import Combine
import SwiftUI


final class SnippetScrollViewModel: ObservableObject, DragabbleObject, QuerySyncableObject, FolderSubjectBindable, FolderMessageSubjectBindable {
    typealias Item = Snippet
    @Published var items: [Snippet] = []
    @Published var allItems: [Snippet] = []
    @Published var selectedFolder: Folder?
    
    var snippetUseCase: SnippetUseCase
    var selectedFolderSubject: CurrentValueSubject<Folder?, Never>
    var controllerSubject: PassthroughSubject<ControllerMessage, Never>
    var snippetSubject: CurrentValueSubject<SnippetMessage?, Never>
    var folderMessageSubject: CurrentValueSubject<FolderMessage?, Never>
    var cancellables: Set<AnyCancellable> = []
        
    init(
        snippetUseCase: SnippetUseCase,
        selectedFolderSubject: CurrentValueSubject<Folder?, Never>,
        controllerSubject: PassthroughSubject<ControllerMessage, Never>,
        snippetSubject: CurrentValueSubject<SnippetMessage?, Never>,
        folderMessageSubject: CurrentValueSubject<FolderMessage?, Never>
    ) {
        self.snippetUseCase = snippetUseCase
        self.selectedFolderSubject = selectedFolderSubject
        self.controllerSubject = controllerSubject
        self.snippetSubject = snippetSubject
        self.folderMessageSubject = folderMessageSubject
        
        setupSelectedFolderBindings()
        setupFilteredSnippetsBindings()
        setupSnippetMessageBindings()
        setupFolderMessageBindings()
    }
    
    func getItems(_ items: [Item]) {
        self.allItems = items
    }
    
    func selectItem(_ itemId: String) {
        let item = items.filter { $0.id == itemId }.first
        if let item = item {
            snippetSubject.send(.snippetSelected(item))
        }
    }
    
    func updateItems() {
        saveChangedItems(as: Snippet.self) { changedItems in
            do {
                try self.snippetUseCase.updateAllSnippets(changedItems)
            } catch {
                print("[ERROR]: SnippetScrollViewModel-updateItems \(error)")
            }
        }
    }
    
    func deleteFolderItems(folderId: String) {
        let filtered = allItems.filter { $0.folderId == folderId }
        for snippet in filtered {
            do {
                try snippetUseCase.deleteSnippet(snippet)
            } catch {
                print("[ERROR]: SnippetScrollViewModel-deleteFolderItems: \(error)")
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.controllerSubject.send(.openPanel)
            self?.folderMessageSubject.send(.switchFirstFolder)
        }
    }
    
    private func setupFolderMessageBindings() {
        folderMessageBindings{ [weak self] message in
            switch message {
            case .deleteFolderItems(let folderId):
                self?.deleteFolderItems(folderId: folderId)
            default:
                return
            }
        }
    }
            
    private func setupFilteredSnippetsBindings() {
        Publishers.CombineLatest($allItems, $selectedFolder)
            .map { snippets, folder -> [Snippet] in
                guard let folder = folder else { return [] }
                return self.getFilterdSnippets(
                    snippets: snippets,
                    folderId: folder.id
                )
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newItems in
                self?.items = newItems
                self?.updateItems()
            }
            .store(in: &cancellables)
    }
    
    private func setupSnippetMessageBindings() {
        snippetSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                guard case .switchFolder = message,
                      let self = self,
                      let folder = self.selectedFolder else { return }
                
                self.items = self.getFilterdSnippets(
                    snippets: self.allItems,
                    folderId: folder.id)
                self.updateItems()
            }
            .store(in: &cancellables)
    }
    
    private func getFilterdSnippets(snippets: [Snippet], folderId: String) -> [Snippet] {
        return snippets.filter { $0.folderId == folderId }
                       .sorted { $0.order < $1.order }
    }        
}
