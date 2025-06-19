//
//  FolderViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 5/29/25.
//

import Foundation
import Combine

final class FolderScrollViewModel: FolderBindableViewModel, DragabbleObject, QuerySyncableObject {        
    typealias Item = Folder
    @Published var items: [Folder] = []
    @Published var allItems: [Folder] = []
    private var useCase: FolderUseCase
    
    init(
        useCase: FolderUseCase,
        selectedFolderSubject: CurrentValueSubject<Folder?, Never>
    ){
        self.useCase = useCase
        super.init(selectedFolderSubject: selectedFolderSubject)
        setupSelectedFolderBindings()
        setSelectedFolder()
    }
    
    func getItems(_ items: [Folder]) {
        DispatchQueue.main.async { [weak self] in
            self?.items = items.sorted { $0.order < $1.order }
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
                try self.useCase.updateAllFolders(changedItems)
            } catch {
                print("[ERROR]: FolderScrollViewModel-updateItems \(error)")
            }
        }                                                       
    }
    
    private func setSelectedFolder() {
        do {
            let folder = try useCase.getFirstFolder()
            self.selectedFolder = folder
            DispatchQueue.main.async { [weak self] in
                self?.selectedFolderSubject.send(folder)
            }
        } catch {
            print("[ERROR]: FolderViewModel - setSelectedFolder: \(error)")
        }
    }
}
