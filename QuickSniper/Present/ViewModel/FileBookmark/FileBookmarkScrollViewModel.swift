//
//  FileBookmarkScrollViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 6/18/25.
//

import Foundation
import SwiftData
import Combine

final class FileBookmarkScrollViewModel: ObservableObject, DragabbleObject, QuerySyncableObject, ControllSubjectBindable, FolderSubjectBindable, FileBookmarkSubjectBindable, FolderMessageSubjectBindable {
        
    typealias Item = FileBookmarkItem
    @Published var items: [FileBookmarkItem] = []
    @Published var allItems: [FileBookmarkItem] = []
    @Published var selectedFolder: Folder?
    
    var usecase: FileBookmarkUseCase
    var controllSubject: PassthroughSubject<ControllerMessage, Never>
    var selectedFolderSubject: CurrentValueSubject<Folder?, Never>
    var fileBookmarkSubject: CurrentValueSubject<FileBookmarkMessage?, Never>
    var folderMessageSubject: CurrentValueSubject<FolderMessage?, Never>
    var cancellables: Set<AnyCancellable> = []
    
    init(
        usecase: FileBookmarkUseCase,
        controllSubject: PassthroughSubject<ControllerMessage, Never>,
        selectedFolderSubject: CurrentValueSubject<Folder?, Never>,
        fileBookmarkSubject: CurrentValueSubject<FileBookmarkMessage?, Never>,
        folderMessageSubject: CurrentValueSubject<FolderMessage?, Never>
        
    ) {
        self.usecase = usecase
        self.controllSubject = controllSubject
        self.selectedFolderSubject = selectedFolderSubject
        self.fileBookmarkSubject = fileBookmarkSubject
        self.folderMessageSubject = folderMessageSubject
        
        setupSelectedFolderBindings()
        setupFileBookmarkMessageBindings()
        setupFolderMessageBindings()
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
    
    func deleteFolderItems(folderId: String) {
        let filtered = allItems.filter { $0.folderId == folderId }
        for item in filtered {
            do {
                try self.usecase.delete(item)
            } catch {
                print("[ERROR]: FileBookmarkScrollViewModel-deleteFolderItems: \(error)")
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.controllSubject.send(.openPanel)
            self?.folderMessageSubject.send(.switchFirstFolder)
        }
    }
            
    func refreshItems() {
        guard let selectedFolder = self.selectedFolder else { return }
        
        self.items = allItems
            .filter { $0.folderId == selectedFolder.id}
            .sorted { $0.order < $1.order }
    }    
}

extension FileBookmarkScrollViewModel {
    private func setupFolderMessageBindings() {
        folderMessageBindings { [weak self] message in
            switch message {
            case .deleteFolderItems(let folderId):
                self?.deleteFolderItems(folderId: folderId)
            default:
                return
            }
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
