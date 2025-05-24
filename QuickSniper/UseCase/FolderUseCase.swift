//
//  FolderUseCase.swift
//  QuickSniper
//
//  Created by 이민호 on 5/23/25.
//

import Foundation

protocol FolderUseCase {
    func createFolder(_ folder: Folder) throws
    func updateFolder(_ folder: Folder) throws
    func deleteFolder(_ folder: Folder) throws
}

final class DefaultFolderUseCase: FolderUseCase {
    private let repository: FolderRepository

    init(repository: FolderRepository) {
        self.repository = repository
    }

    func createFolder(_ folder: Folder) throws {
        try repository.save(folder)
    }

    func updateFolder(_ folder: Folder) throws {
        try repository.update(folder)
    }

    func deleteFolder(_ folder: Folder) throws {
        try repository.delete(folder)
    }
}
