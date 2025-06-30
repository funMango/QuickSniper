//
//  UrlBookmarkUseCase.swift
//  Shifty
//
//  Created by 이민호 on 6/27/25.
//

import Foundation
import SwiftData

protocol UrlBookmarkUseCase {
    func save(_ item: UrlBookmark)
    func update(_ item: UrlBookmark)
    func updateFolder(_ item: UrlBookmark)
    func updateAll(_ items: [UrlBookmark])
    func delete(_ item: UrlBookmark)
    func deleteAll()
}

final class DefaultUrlBookmarkUseCase: UrlBookmarkUseCase {
    private let repository: UrlBookmarkRepository
    
    init(repository: UrlBookmarkRepository) {
        self.repository = repository
    }
    
    func save(_ item: UrlBookmark) {
        do {
            let order = try repository.fetchAll().filter{ $0.folderId == item.folderId }.count + 1
            item.updateOrder(order)
            try repository.save(item)
        } catch {
            print("[ERROR]: DefaultUrlBookmarkUseCase-save: \(error)")
        }
    }
    
    func update(_ item: UrlBookmark) {
        do {
            try repository.update(item)
        } catch {
            print("[ERROR]: DefaultUrlBookmarkUseCase-update: \(error)")
        }
        
    }
    
    func updateFolder(_ item: UrlBookmark) {
        do {
            let order = try repository.fetchAll().filter { $0.folderId == item.folderId }.count + 1
            item.updateOrder(order)
            update(item)
        } catch {
            print("[ERROR]: DefaultFileBookmarkUseCase-updateFolder: \(error)")
        }
    }
    
    func updateAll(_ items: [UrlBookmark]) {
        for item in items {
            update(item)
        }
    }
        
    func delete(_ item: UrlBookmark) {
        do {
            try repository.delete(item)
        } catch {
            print("[ERROR]: DefaultFileBookmarkUseCase-delete: \(error)")
        }
    }
    
    func deleteAll() {
        do {
            try repository.deleteAll()
        } catch {
            print("[ERROR]: DefaultFileBookmarkUseCase-deleteAll: \(error)")
        }
    }
}
