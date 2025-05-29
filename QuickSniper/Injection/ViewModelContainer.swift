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
    
    private let controllerSubject: PassthroughSubject<ControllerMessage, Never>
    private let folderSubject: CurrentValueSubject<Folder?, Never>
    private let folderEditSubject: PassthroughSubject<Folder, Never>
    private let geometrySubject: CurrentValueSubject<CGRect, Never>
    
    private lazy var folderRepository = DefaultFolderRepository(context: modelContext)
    private lazy var folderUseCase = DefaultFolderUseCase(repository: folderRepository)
    
    init(
        modelContext: ModelContext,
        controllerSubject: PassthroughSubject<ControllerMessage, Never>,
        folderSubject: CurrentValueSubject<Folder?, Never>,
        folderEditSubject:PassthroughSubject<Folder, Never>,
        geometrySubject: CurrentValueSubject<CGRect, Never>
    ){
        self.modelContext = modelContext
        self.controllerSubject = controllerSubject
        self.folderSubject = folderSubject
        self.folderEditSubject = folderEditSubject
        self.geometrySubject = geometrySubject
    }
                
    lazy var noteEditorViewModel = NoteEditorViewModel(
        subject: controllerSubject
    )
    
    lazy var createFolderViewModel = CreateFolderViewModel(
        useCase: folderUseCase,
        subject: controllerSubject
    )
    
    lazy var folderButtonViewModel = FolderButtonViewModel(
        folderSubject: folderSubject,
        geometrySubject: geometrySubject
    )
    
    lazy var deleteFolderViewModel = DeleteFolderViewModel(
        folderSubject: folderSubject,
        folderUseCase: folderUseCase,
    )
    
    lazy var editFolderViewModel = EditFolderViewModel(
        folderSubject: folderSubject,
        folderEditSubject: folderEditSubject
    )
    
    func getRenameableButtonViewModel(folder: Folder) ->  RenameableButtonViewModel{
        return RenameableButtonViewModel(
            folder: folder,
            folderUseCase: folderUseCase,
            folderEditSubject: folderEditSubject
        )
    }
}
