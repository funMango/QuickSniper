//
//  FileBookmarkRepository.swift
//  QuickSniper
//
//  Created by 이민호 on 6/16/25.
//

import Foundation
import SwiftData

protocol FileBookmarkRepository {
    func save(_ item: FileBookmarkItem) throws
    func update(_ item: FileBookmarkItem) throws
    func delete(_ item: FileBookmarkItem) throws
    func deleteAll() throws
    func fetchAll() throws -> [FileBookmarkItem]
}

final class DefaultFileBookmarkRepository: FileBookmarkRepository {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func save(_ item: FileBookmarkItem) throws {
        context.insert(item)
        try context.save()
        print("FileBookmarkItem 저장: \(item.name)")
    }
    
    func update(_ item: FileBookmarkItem) throws {
        guard let existing = try fetchAll().first(where: { $0.id == item.id }) else {
            throw NSError(
                domain: "FileBookmarkRepository",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "FileBookmark not found"]
            )
        }
        
        existing.name = item.name
        existing.type = item.type
        existing.bookmarkData = item.bookmarkData
        existing.iconData = item.iconData
        existing.order = item.order
        
        try context.save()
        
        print("FileBookmarkItem 업데이트: \(item.name)")
    }
            
    func delete(_ item: FileBookmarkItem) throws {
        context.delete(item)
        try context.save()
        print("FileBookmarkItem 제거: \(item.name)")
    }
    
    func deleteAll() throws {
        let items =  try fetchAll()
        
        for item in items {
            try delete(item)
        }
        
        print("FileBookmarkItem 전체삭제")
    }
    
    func fetchAll() throws -> [FileBookmarkItem] {
        let descriptor = FetchDescriptor<FileBookmarkItem>(sortBy: [SortDescriptor(\.order)])
        return try context.fetch(descriptor)
    }
}
