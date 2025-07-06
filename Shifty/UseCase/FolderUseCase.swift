//
//  FolderUseCase.swift
//  QuickSniper
//
//  Created by 이민호 on 5/23/25.
//

import Foundation

protocol FolderUseCase {
    func getFolderCount() throws -> Int
    func createFolder(_ folder: Folder) throws
    func updateFolder(_ folder: Folder) throws
    func updateAllFolders(_ folders: [Folder]) throws
    func deleteFolder(_ folder: Folder) throws
    func getFirstFolder() throws -> Folder?
    func fetchAll() throws -> [Folder]
}

final class DefaultFolderUseCase: FolderUseCase {
    private let repository: FolderRepository

    init(repository: FolderRepository) {
        self.repository = repository
    }
    
    func fetchAll() throws -> [Folder] {
        return try repository.fetchAll()
    }
    
    func getFolderCount() throws -> Int {
        return try repository.fetchAll().count
    }

    func createFolder(_ folder: Folder) throws {
        do {
            let order = try repository.fetchAll().count + 1
            folder.updateOrder(order)
            try repository.save(folder)
        } catch {
            print("[Error]: Failed to get Folder order")
        }        
    }

    func updateFolder(_ folder: Folder) throws {
        try repository.update(folder)
    }
    
    func updateAllFolders(_ folders: [Folder]) throws {
        for folder in folders {
            try updateFolder(folder)
        }
    }

    func deleteFolder(_ folder: Folder) throws {
        try repository.delete(folder)
    }
    
    func getFirstFolder() throws -> Folder? {
        return try repository.fetchAll().first
    }
            
    private func getOrder() throws -> Int {
        return try repository.fetchAll().count
    }
    
    private func getFolder(name: String, type: FolderType, order: Int) -> Folder {
        return Folder(name: name, type: type, order: order)
    }
}
