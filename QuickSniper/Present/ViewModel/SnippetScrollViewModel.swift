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
    private var cancellables: Set<AnyCancellable> = []
    
    
    init(
        snippetUseCase: SnippetUseCase,
        selectedFolderSubject: CurrentValueSubject<Folder?, Never>,
        controllerSubject: PassthroughSubject<ControllerMessage, Never>
    ) {
        self.snippetUseCase = snippetUseCase
        self.selectedFolderSubject = selectedFolderSubject
        self.controllerSubject = controllerSubject
        setupSelectedFolderBindings()
    }
    
    func getItems(_ items: [Item]) {
        DispatchQueue.main.async { [weak self] in
            self?.allItems = items
        }
    }
    
    func updateItems() {
        for (i, s) in items.enumerated() {
            s.order = i
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
            .sink { [weak self] allSnippets, selectedFolder in
                guard selectedFolder != nil else { return }
                                                                       
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    if let folder = selectedFolder {
                        self.items = self.allItems
                                         .filter { $0.folderId == folder.id }
                                         .sorted { $0.order < $1.order }
                    } else {
                        self.items = []
                    }
                    
//                    DispatchQueue.main.async { [weak self] in
//                        self?.controllerSubject.send(.togglePanel)
//                    }
                }
            }
            .store(in: &cancellables)
    }
}
