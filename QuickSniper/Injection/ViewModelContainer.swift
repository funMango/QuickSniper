//
//  ViewModelContainer.swift
//  QuickSniper
//
//  Created by 이민호 on 5/23/25.
//

import Foundation
import SwiftData
import Combine

final class ViewModelContainer {
    private let modelContext: ModelContext
    private let controllerSubject : PassthroughSubject<ControllerMessage, Never>
    private let folderSubject: CurrentValueSubject<Folder?, Never>
    private lazy var folderRepository = DefaultFolderRepository(context: modelContext)
    private lazy var folderUseCase = DefaultFolderUseCase(repository: folderRepository)
    
    init(
        modelContext: ModelContext,
        controllerSubject: PassthroughSubject<ControllerMessage, Never>,
        folderSubject: CurrentValueSubject<Folder?, Never>
    ){
        self.modelContext = modelContext
        self.controllerSubject = controllerSubject
        self.folderSubject = folderSubject
    }
                
    lazy var noteEditorViewModel = NoteEditorViewModel(
        subject: controllerSubject
    )
    
    lazy var createFolderViewModel = CreateFolderViewModel(
        useCase: folderUseCase,
        subject: controllerSubject
    )
    
    lazy var folderButtonViewModel = FolderButtonViewModel(
        folderSubject: folderSubject
    )
    
    lazy var deleteFolderViewModel = DeleteFolderViewModel(
        folderSubject: folderSubject,
        folderUseCase: folderUseCase,
    )
}
