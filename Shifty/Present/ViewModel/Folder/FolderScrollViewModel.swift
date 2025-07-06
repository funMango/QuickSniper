//
//  FolderViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 5/29/25.
//

import Foundation
import Combine
import Resolver

final class FolderScrollViewModel: DragabbleObject {
        
    typealias Item = Folder
    @Published var items: [Folder] = []
    @Published var allItems: [Folder] = []
    @Published var selectedFolder: Folder?
    @Injected var folderSubject: CurrentValueSubject<FolderMessage?, Never>
    
    var folderUsecase: FolderUseCase
    var cancellables: Set<AnyCancellable> = []
    private var itemsById: [String: Folder] = [:]
    
    init(folderUsecase: FolderUseCase){
        self.folderUsecase = folderUsecase
                
        fetchFolders()
        folderMessageBindings()
        setSelectedFolder()
    }
    
    func fetchFolders() {
        do {
            self.items = try folderUsecase.fetchAll()
        } catch {
            print("[ERROR] Folder Fetch Error: \(error.localizedDescription)")
        }
    }
    
    func getItems(_ items: [Folder]) {
        DispatchQueue.main.async { [weak self] in
            self?.items = items.sorted { $0.order < $1.order }
            
            // Dictionary 캐시 생성 (O(1) 조회)
            self?.itemsById = Dictionary(uniqueKeysWithValues: items.map { ($0.id, $0) })
            
            if self?.items.count == 1 {
                let itemId = self?.items[0].id ?? ""
                self?.selectItem(itemId)
            }
        }
    }
    
    func selectItem(_ itemId: String) {
        let item =  self.items.filter { $0.id == itemId }.first
        
        guard let item = item  else {
            return
        }
        
        folderSubject.send(.switchCurrentFolder(item))
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
    
    private func folderMessageBindings() {
        folderSubject.sink { [weak self] message in
            switch message {
            case .switchFirstFolder:
                self?.setSelectedFolder()
            case .switchCurrentFolder(let folder):
                self?.selectedFolder = folder
            default:
                break
            }
        }
        .store(in: &cancellables)
    }
    
    private func setSelectedFolder() {
        do {
            let folder = try folderUsecase.getFirstFolder()
            if let folder = folder {
                DispatchQueue.main.async { [weak self] in
                    self?.folderSubject.send(.switchCurrentFolder(folder))
                }
            }
        } catch {
            print("[ERROR]: FolderViewModel-setSelectedFolder: \(error)")
        }
    }
}
