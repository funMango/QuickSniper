//
//  SnippetUseCase.swift
//  QuickSniper
//
//  Created by 이민호 on 5/29/25.
//

import Foundation

protocol SnippetUseCase {
    func createSnippet(folderId: String, title: String, body: String)
    func updateFolder(_ snippet: Snippet) throws
    func deleteFolder(_ snippet: Snippet) throws
}

final class DefaultSnippetUseCase: SnippetUseCase {
    private let repository: SnippetRepository
    
    init(repository: SnippetRepository) {
        self.repository = repository
    }
    
    func createSnippet(folderId: String, title: String, body: String) {
        do {
            let order = try repository.fetchAll().count
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
    
    func updateFolder(_ snippet: Snippet) throws {        
        try repository.update(snippet)
    }

    func deleteFolder(_ snippet: Snippet) throws {
        try repository.delete(snippet)
    }
}
