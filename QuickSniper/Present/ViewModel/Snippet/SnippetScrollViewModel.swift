//
//  SnippetScrollViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 5/30/25.
//

import Foundation
import Combine
import SwiftUI


final class SnippetScrollViewModel: ObservableObject, DragabbleObject, QuerySyncableObject {
    typealias Item = Snippet
    @Published var items: [Snippet] = []
    @Published var allItems: [Snippet] = []
    @Published private var selectedFolder: Folder?
    
    private var snippetUseCase: SnippetUseCase
    private var selectedFolderSubject: CurrentValueSubject<Folder?, Never>
    private var controllerSubject: PassthroughSubject<ControllerMessage, Never>
    private var snippetSubject: CurrentValueSubject<SnippetMessage?, Never>
    private var cancellables: Set<AnyCancellable> = []
        
    init(
        snippetUseCase: SnippetUseCase,
        selectedFolderSubject: CurrentValueSubject<Folder?, Never>,
        controllerSubject: PassthroughSubject<ControllerMessage, Never>,
        snippetSubject: CurrentValueSubject<SnippetMessage?, Never>
    ) {
        self.snippetUseCase = snippetUseCase
        self.selectedFolderSubject = selectedFolderSubject
        self.controllerSubject = controllerSubject
        self.snippetSubject = snippetSubject
        
        setupSelectedFolderBindings()
        setupSnippetMessageBindings()
    }
    
    func getItems(_ items: [Item]) {
        self.allItems = items
    }
    
    func updateItems() {
        for (i, s) in items.enumerated() {
            s.updateOrder(i + 1)
        }
        
        do {
            try self.snippetUseCase.updateAllSnippets(items)
        } catch {
            print("[ERROR]: SnippetScrollViewModel-updateItems \(error)")
        }
    }
    
    private func setupSelectedFolderBindings() {
        selectedFolderSubject
            .assign(to: &$selectedFolder)

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
                self?.selectFirstSnippet()
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
    
    private func selectFirstSnippet() {
        if let selected = self.items.first {            
            snippetSubject.send(.snippetSelected(selected))
        }
    }
}
