//
//  FolderViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 5/29/25.
//

import Foundation
import Combine

final class FolderScrollViewModel: FolderSubjectBindable, DragabbleObject, QuerySyncableObject, FolderMessageSubjectBindable {
        
    typealias Item = Folder
    @Published var items: [Folder] = []
    @Published var allItems: [Folder] = []
    @Published var selectedFolder: Folder?
    var folderUsecase: FolderUseCase
    var selectedFolderSubject: CurrentValueSubject<Folder?, Never>
    var folderMessageSubject: CurrentValueSubject<FolderMessage?, Never>
    var cancellables: Set<AnyCancellable> = []
    
    init(
        folderUsecase: FolderUseCase,
        selectedFolderSubject: CurrentValueSubject<Folder?, Never>,
        folderMessageSubject: CurrentValueSubject<FolderMessage?, Never>
    ){
        self.folderUsecase = folderUsecase
        self.selectedFolderSubject = selectedFolderSubject
        self.folderMessageSubject = folderMessageSubject
        
        setupSelectedFolderBindings()
        setupFolderMessageBindings()
        setSelectedFolder()
    }
    
    func getItems(_ items: [Folder]) {
        DispatchQueue.main.async { [weak self] in
            self?.items = items.sorted { $0.order < $1.order }
            if self?.items.count == 1 {
                let itemId = self?.items[0].id ?? ""
                self?.selectItem(itemId)
            }
        }
    }
    
    func selectItem(_ itemId: String) {
        let item = items.filter{ $0.id == itemId }.first
        if let item = item {
            selectedFolderSubject.send(item)
        }
    }
    
    func updateItems() {
        saveChangedItems(as: Folder.self) { changedItems in
            do {
                try self.folderUsecase.updateAllFolders(changedItems)
            } catch {
                print("[ERROR]: FolderScrollViewModel-updateItems \(error)")
            }
        }                                                       
    }
    
    private func setupFolderMessageBindings() {
        folderMessageBindings{ [weak self] message in
            switch message {
            case .switchFirstFolder:
                self?.setSelectedFolder()
            default:
                break
            }
        }
    }
    
    private func setSelectedFolder() {
        do {
            let folder = try folderUsecase.getFirstFolder()            
            DispatchQueue.main.async { [weak self] in
                self?.selectedFolderSubject.send(folder)
            }
        } catch {
            print("[ERROR]: FolderViewModel-setSelectedFolder: \(error)")
        }
    }
}
