//
//  SnippetRepository.swift
//  QuickSniper
//
//  Created by 이민호 on 5/29/25.
//

import Foundation
import SwiftData

protocol SnippetRepository {
    func save(_ snippet: Snippet) throws
    func delete(_ folsnippetder: Snippet) throws
    func update(_ snippet: Snippet) throws
    func fetchAll() throws -> [Snippet]
    func fetchByFolderId(_ folderId: String) throws -> [Snippet]
}

final class DefaultSnippetRepository: SnippetRepository {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func save(_ snippet: Snippet) throws {
        context.insert(snippet)
        try context.save()
        print("스니펫 저장: \(snippet.title)")
    }

    func delete(_  snippet: Snippet) throws {
        context.delete(snippet)
        try context.save()
        print("스니펫 제거: \(snippet.title)")
    }

    func update(_ snippet: Snippet) throws {
        guard let existing = try fetchAll().first(where: { $0.id == snippet.id }) else {
            throw NSError(
                domain: "SnippetRepository",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "Snippet not found"]
            )
        }
                
        existing.title = snippet.title
        existing.body = snippet.body
        existing.order = snippet.order
        existing.folderId = snippet.folderId

        try context.save()
    }
    
    func fetchAll() throws -> [Snippet] {
        let descriptor = FetchDescriptor<Snippet>(sortBy: [SortDescriptor(\.order)])
        return try context.fetch(descriptor)
    }
    
    func fetchByFolderId(_ folderId: String) throws -> [Snippet] {
        let descriptor = FetchDescriptor<Snippet>(
            predicate: #Predicate { $0.folderId == folderId },
            sortBy: [SortDescriptor(\.order)]
        )
        return try context.fetch(descriptor)
    }
}
