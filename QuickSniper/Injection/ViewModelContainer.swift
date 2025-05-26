//
//  ViewModelContainer.swift
//  QuickSniper
//
//  Created by 이민호 on 5/23/25.
//

import Foundation
import SwiftData

final class ViewModelContainer {
    private let modelContext: ModelContext
    private lazy var folderRepository = DefaultFolderRepository(context: modelContext)
    private lazy var folderUseCase = DefaultFolderUseCase(repository: folderRepository)
        
    lazy var noteEditorViewModel = NoteEditorViewModel()
    lazy var createFolderViewModel = CreateFolderViewModel(useCase: folderUseCase)
                
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
}
