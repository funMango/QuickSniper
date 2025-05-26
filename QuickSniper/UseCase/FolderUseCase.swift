//
//  FolderUseCase.swift
//  QuickSniper
//
//  Created by 이민호 on 5/23/25.
//

import Foundation

protocol FolderUseCase {
    func createFolder(name: String, type: FolderType) throws
    func updateFolder(_ folder: Folder) throws
    func deleteFolder(_ folder: Folder) throws
}

final class DefaultFolderUseCase: FolderUseCase {
    private let repository: FolderRepository

    init(repository: FolderRepository) {
        self.repository = repository
    }

    func createFolder(name: String, type: FolderType) throws {
        do {
            let order = try repository.fetchAll().count
            let folder = getFolder(name: name, type: type, order: order)
            try repository.save(folder)
        } catch {
            print("[Error]: Failed to get Folder order")
        }        
    }

    func updateFolder(_ folder: Folder) throws {
        try repository.update(folder)
    }

    func deleteFolder(_ folder: Folder) throws {
        try repository.delete(folder)
    }
    
    private func getOrder() throws -> Int {
        do {
            return try repository.fetchAll().count
        }
    }
    
    private func getFolder(name: String, type: FolderType, order: Int) -> Folder {
        return Folder(name: name, type: type, order: order)
    }
}
