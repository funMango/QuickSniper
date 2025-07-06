//
//  SnippetService.swift
//  Shifty
//
//  Created by 이민호 on 7/6/25.
//

import Foundation

protocol SnippetService {
    func save(_ snippet: Snippet) throws
    func createSnippet(folderId: String, title: String, body: String)
    func updateSnippet(_ snippet: Snippet) throws
    func updateSnippetFolder(_ snippet: Snippet) throws
    func updateAllSnippets(_ snippets: [Snippet]) throws
    func deleteSnippet(_ snippet: Snippet) throws
    func fetchAll() throws -> [Snippet]
}

final class DefaultSnippetService: SnippetService {
    private let repository: SnippetRepository
    
    init(repository: SnippetRepository) {
        self.repository = repository
    }
    
    func save(_ snippet: Snippet) throws {
        try repository.save(snippet)
    }
    
    func createSnippet(folderId: String, title: String, body: String) {
        do {
            let order = try repository.fetchByFolderId(folderId).count
            let snippet = Snippet(
                folderId: folderId,
                title: title,
                body: body,
                order: order
            )
            try repository.save(snippet)
        } catch {
            print("[ERROR]: SnippetUseCase - createSnippet: \(error)")
        }
    }
    
    func updateSnippet(_ snippet: Snippet) throws {
        try repository.update(snippet)
    }
    
    func updateSnippetFolder(_ snippet: Snippet) throws {
        let order = try repository.fetchByFolderId(snippet.folderId).count
        snippet.updateOrder(order)
        try repository.update(snippet)
    }
    
    func updateAllSnippets(_ snippets: [Snippet]) throws {
        for snippet in snippets {
            try updateSnippet(snippet)
        }
    }

    func deleteSnippet(_ snippet: Snippet) throws {
        try repository.delete(snippet)
    }
    
    func fetchAll() throws -> [Snippet] {
        try repository.fetchAll()
    }
}

