//
//  UrlBookmarkRepository.swift
//  Shifty
//
//  Created by 이민호 on 6/27/25.
//

import Foundation
import SwiftData

protocol UrlBookmarkRepository {
    func save(_ item: UrlBookmark) throws
    func update(_ item: UrlBookmark) throws
    func delete(_ item: UrlBookmark) throws
    func deleteAll() throws
    func fetchAll() throws -> [UrlBookmark]
}

final class DefaultUrlBookmarkRepository: UrlBookmarkRepository {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func save(_ item: UrlBookmark) throws {
        context.insert(item)
        try context.save()
        print("UrlBookmark 저장: \(item.title)")
    }
    
    func update(_ item: UrlBookmark) throws {
        guard let existing = try fetchAll().first(where: { $0.id == item.id }) else {
            throw NSError(
                domain: "UrlBookmark",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "UrlBookmark not found"]
            )
        }
        
        existing.folderId = item.folderId
        existing.title = item.title
        existing.url = item.url
        existing.iconData = item.iconData
        existing.order = item.order
        
        try context.save()
        
        print("FileBookmarkItem 업데이트: \(item.title)")
    }
    
    func delete(_ item: UrlBookmark) throws {
        context.delete(item)
        try context.save()
        print("UrlBookmark 제거: \(item.title)")
    }
    
    func deleteAll() throws {
        let items =  try fetchAll()
        
        for item in items {
            try delete(item)
        }
        
        print("UrlBookmark 전체삭제")
    }
    
    func fetchAll() throws -> [UrlBookmark] {
        let descriptor = FetchDescriptor<UrlBookmark>(sortBy: [SortDescriptor(\.order)])
        return try context.fetch(descriptor)
    }
}
