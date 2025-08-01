//
//  CoreModelUseCase.swift
//  Shifty
//
//  Created by 이민호 on 7/1/25.
//

import Foundation

protocol CoreModelUseCase {
    func fetch() -> [any CoreModel]
    func save(_ item: any CoreModel)
    func saveAll(_ items: [any CoreModel])
}

final class DefaultCoreModelUseCase: CoreModelUseCase {
    let snippetUseCase: SnippetUseCase
    let fileBookmarkUseCase: FileBookmarkUseCase
    
    init(
        snippetUsecase: SnippetUseCase,
        fileBookmarkUsecase: FileBookmarkUseCase
    ) {
        self.snippetUseCase = snippetUsecase
        self.fileBookmarkUseCase = fileBookmarkUsecase
    }
    
    func fetch() -> [any CoreModel] {
        let snippets = fetchSnippets()
        let fileBookmarks = fetchFileBookmarks()
        let allCoreModels = mergeCoreModels(
            snippets: snippets,
            fileBookmarks: fileBookmarks
        )
                                
        return allCoreModels.sorted{ $0.order < $1.order }
    }
    
    private func mergeCoreModels(snippets: [any CoreModel]?, fileBookmarks: [any CoreModel]?) -> [any CoreModel] {
        
        let unwrappedSnippets: [any CoreModel] = snippets ?? []
        let unwrappedFileBookmarks: [any CoreModel] = fileBookmarks ?? []

        
        return unwrappedSnippets + unwrappedFileBookmarks
    }
    
    func save(_ item: any CoreModel) {
        let order = self.fetch().count + 1
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
            let order = self.fetch().count + 1
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
