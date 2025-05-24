//
//  FolderRepository.swift
//  QuickSniper
//
//  Created by 이민호 on 5/23/25.
//

import Foundation
import SwiftData

protocol FolderRepository {
    func save(_ folder: Folder) throws
    func delete(_ folder: Folder) throws
    func update(_ folder: Folder) throws
}

final class DefaultFolderRepository: FolderRepository {
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func save(_ folder: Folder) throws {
        context.insert(folder)
        try context.save()
    }

    func delete(_ folder: Folder) throws {
        context.delete(folder)
        try context.save()
    }

    func update(_ folder: Folder) throws {
        try context.save()
    }
}

