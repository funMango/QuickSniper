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

    func update(_  snippet: Snippet) throws {
        try context.save()
    }
    
    func fetchAll() throws -> [Snippet] {
        let descriptor = FetchDescriptor<Snippet>(sortBy: [SortDescriptor(\.order)])
        return try context.fetch(descriptor)
    }
}
