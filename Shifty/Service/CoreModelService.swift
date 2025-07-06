//
//  CoreModelService.swift
//  Shifty
//
//  Created by 이민호 on 7/6/25.
//

import Foundation

protocol CoreModelService {
    func fetch() -> [any CoreModel]
    func save(_ item: any CoreModel)
    func saveAll(_ items: [any CoreModel])
}

final class DefaultCoreModelService: CoreModelService {
    let snippetUseCase: SnippetUseCase
    let fileBookmarkUseCase: FileBookmarkUseCase
    
    init(
        snippetUsecase: SnippetUseCase,
        fileBookmarkUsecase: FileBookmarkUseCase
    ) {
        self.snippetUseCase = snippetUsecase
        self.fileBookmarkUseCase = fileBookmarkUsecase
    }

    // MARK: - Main Function
    func fetch() -> [any CoreModel] {
        let snippets = fetchSnippets()
        let fileBookmarks = fetchFileBookmarks()
        let allCoreModels = mergeCoreModels(
            snippets: snippets,
            fileBookmarks: fileBookmarks
        )
                                
        return allCoreModels.sorted{ $0.order < $1.order }
    }
    
    func fetchByFolder(id: String) -> [any CoreModel] {
        let snippets = fetchSnippets()?.filter { $0.folderId == id }
        let fileBookmarks = fetchFileBookmarks()?.filter { $0.folderId == id }
        let allCoreModels = mergeCoreModels(snippets: snippets, fileBookmarks: fileBookmarks)
        
        return allCoreModels.sorted{ $0.order < $1.order }
    }
    
    
    
    func save(_ item: any CoreModel) {
        let order = self.fetchByFolder(id: item.folderId).count + 1
        item.updateOrder(order)
        
        if let snippet = item as? Snippet {
            do {
                try snippetUseCase.save(snippet)
            } catch {
                print("[ERROR]: DefaultCoreModelUseCase-save,snippet, error: \(error)")
            }
        }
    }
    
    func saveAll(_ items: [any CoreModel]) {
        for item in items {
            let order = self.fetchByFolder(id: item.folderId).count + 1
            item.updateOrder(order)
            
            DispatchQueue.main.async { [weak self] in
                if let fileBookmark = item as? FileBookmarkItem {
                    do {
                        print(fileBookmark.name)
                        try self?.fileBookmarkUseCase.save(fileBookmark)
                    } catch {
                        print("[ERROR]: DefaultCoreModelUseCase-save,fileBookmark, error: \(error)")
                    }
                }
            }
        }
    }
    
    // MARK: - Sub Function
    private func mergeCoreModels(snippets: [any CoreModel]?, fileBookmarks: [any CoreModel]?) -> [any CoreModel] {
        let unwrappedSnippets: [any CoreModel] = snippets ?? []
        let unwrappedFileBookmarks: [any CoreModel] = fileBookmarks ?? []
        
        return unwrappedSnippets + unwrappedFileBookmarks
    }
    
    private func fetchSnippets() -> [any CoreModel]? {
        do {
            return try snippetUseCase.fetchAll()
        } catch {
            print("[ERROR]: DefaultCoreModelUseCase-fetchSnippets, error: \(error)")
        }
        
        return nil
    }
    
    private func fetchFileBookmarks() -> [any CoreModel]? {
        do {
            return try fileBookmarkUseCase.fetchAll()
        } catch {
            print("DefaultCoreModelUseCase-fetchFileBookmarks, error: \(error)")
        }
        
        return nil
    }
}
