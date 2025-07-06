//
//  FileBookmarkService.swift
//  Shifty
//
//  Created by 이민호 on 7/6/25.
//

import Foundation

protocol FileBookmarkService {
    func save(_ item: FileBookmarkItem) throws
    func saveAll(_ items: [FileBookmarkItem]) throws
    func update(_ item: FileBookmarkItem) throws
    func updateFolder(_ item: FileBookmarkItem) throws
    func updateAll(_ items: [FileBookmarkItem]) throws
    func delete(_ item: FileBookmarkItem) throws
    func deleteAll() throws
    func fetchAll() throws -> [FileBookmarkItem]
}

final class DefaultFileBookmarkService: FileBookmarkService {
    private let repository: FileBookmarkRepository
    
    init(repository: FileBookmarkRepository) {
        self.repository = repository
    }
    
    func save(_ item: FileBookmarkItem) throws {
        do {
            let order = try repository.fetchAll().filter{ $0.folderId == item.folderId }.count + 1
            item.setOrder(order)
            try repository.save(item)
        } catch {
            print("[ERROR]: DefaultFileBookmarkUseCase-save: \(error)")
        }
    }
    
    func saveAll(_ items: [FileBookmarkItem]) throws {
        let original = items
        
        do {
            for item in items {
                try save(item)
            }
            print("[SUCCESS]: 모든 파일 북마크 저장 완료")
        } catch {
            try rollback(to: original)
            print("[ERROR]: DefaultFileBookmarkUseCase-saveItems: \(error)")
        }
    }
    
    private func rollback(to items: [FileBookmarkItem]) throws {
        try repository.deleteAll()
        
        for item in items {
            try repository.save(item)
        }
        
        print("[ROLLBACK]: [FileBookmarkItem] 복구완료")
    }
    
    func update(_ item: FileBookmarkItem) throws {
        try repository.update(item)
    }
    
    func updateFolder(_ item: FileBookmarkItem) throws {
        do {
            let order = try repository.fetchAll().filter { $0.folderId == item.folderId }.count + 1
            item.updateOrder(order)
            try update(item)
        } catch {
            print("[ERROR]: DefaultFileBookmarkUseCase-updateFolder: \(error)")
        }
    }
    
    func updateAll(_ items: [FileBookmarkItem]) throws {
        do {
            for item in items {
                try update(item)
            }
        } catch {
            throw error
        }
    }
    
    func delete(_ item: FileBookmarkItem) throws {
        try repository.delete(item)
    }
    
    func deleteAll() throws {
        try repository.deleteAll()
    }
    
    func fetchAll() throws -> [FileBookmarkItem] {
        return try repository.fetchAll()
    }
}

