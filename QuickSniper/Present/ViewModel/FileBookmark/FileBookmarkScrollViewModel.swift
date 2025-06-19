//
//  FileBookmarkScrollViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 6/18/25.
//

import Foundation
import SwiftData
import Combine

final class FileBookmarkScrollViewModel: ObservableObject, DragabbleObject, QuerySyncableObject, FolderSubjectBindable, FileBookmarkSubjectBindable {
    typealias Item = FileBookmarkItem
    @Published var items: [FileBookmarkItem] = []
    @Published var allItems: [FileBookmarkItem] = []
    @Published var selectedFolder: Folder?
    
    var usecase: FileBookmarkUseCase
    var selectedFolderSubject: CurrentValueSubject<Folder?, Never>
    var fileBookmarkSubject: CurrentValueSubject<FileBookmarkMessage?, Never>
    var cancellables: Set<AnyCancellable> = []
    
    init(
        usecase: FileBookmarkUseCase,
        selectedFolderSubject: CurrentValueSubject<Folder?, Never>,
        fileBookmarkSubject: CurrentValueSubject<FileBookmarkMessage?, Never>
        
    ) {
        self.usecase = usecase
        self.selectedFolderSubject = selectedFolderSubject
        self.fileBookmarkSubject = fileBookmarkSubject
        
        setupSelectedFolderBindings()
        setupFileBookmarkMessageBindings()
        setupItemsBinding()
    }
        
    func getItems(_ items: [FileBookmarkItem]) {
        self.allItems = items
    }
    
    func updateItems() {
        saveChangedItems(as: FileBookmarkItem.self) { changedItems in
            do {
                try self.usecase.updateAll(changedItems)
            } catch {
                print("[ERROR]: FileBookmarkScrollViewModel-updateItems: \(error)")
            }
        }
    }
    
    func selectItem(_ itemId: String) {
        let item = items.first(where: { $0.id == itemId })
        if let item = item {
            fileBookmarkSubject.send(.switchSelectedBookmarkItem(item))
        }
    }
    
    private func setupFileBookmarkMessageBindings() {
        fileBookmarkMessageBindings { [weak self] message in
            switch message {
            case .refreshBookmarkItems:
                self?.refreshItems()
            default:
                break
            }
        }
    }
    
    func refreshItems() {
        guard let selectedFolder = self.selectedFolder else { return }
        
        self.items = allItems
            .filter { $0.folderId == selectedFolder.id}
            .sorted { $0.order < $1.order }
    }
    
    private func setupItemsBinding() {
        Publishers.CombineLatest($allItems, $selectedFolder)
            .map { items, folder -> [FileBookmarkItem] in
                guard let folder = folder else { return [] }
                return items
                    .filter { $0.folderId == folder.id }
                    .sorted { $0.order < $1.order }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newItems in
                self?.items = newItems                
            }
            .store(in: &cancellables)
    }
}
