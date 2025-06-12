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
    private let selectedFolderSubject: CurrentValueSubject<Folder?, Never>
    private let geometrySubject: CurrentValueSubject<CGRect, Never>
    private let snippetSubject: CurrentValueSubject<SnippetMessage?, Never>
    private let serviceSubject: CurrentValueSubject<ServiceMessage?, Never>
    
    private var snippetCardViewModelCache: [String: SnippetCardViewModel] = [:]
    
    private lazy var folderRepository = DefaultFolderRepository(context: modelContext)
    private lazy var snippetRepository = DefaultSnippetRepository(context: modelContext)
    
    private lazy var folderUseCase = DefaultFolderUseCase(repository: folderRepository)
    private lazy var snippetUseCase = DefaultSnippetUseCase(repository: snippetRepository)
            
    init(
        modelContext: ModelContext,
        controllerSubject: PassthroughSubject<ControllerMessage, Never>,
        folderSubject: CurrentValueSubject<Folder?, Never>,
        folderEditSubject:PassthroughSubject<Folder, Never>,
        selectedFolderSubject: CurrentValueSubject<Folder?, Never>,
        geometrySubject: CurrentValueSubject<CGRect, Never>,
        snippetSubject: CurrentValueSubject<SnippetMessage?, Never>,
        serviceSubject: CurrentValueSubject<ServiceMessage?, Never>
    ){
        self.modelContext = modelContext
        self.controllerSubject = controllerSubject
        self.folderSubject = folderSubject
        self.folderEditSubject = folderEditSubject
        self.selectedFolderSubject = selectedFolderSubject
        self.geometrySubject = geometrySubject
        self.snippetSubject = snippetSubject
        self.serviceSubject = serviceSubject
    }
    
    //MARK: - Snippet
    lazy var snippetEditorViewModel = SnippetEditorViewModel(
        subject: controllerSubject,
        selectedFolderSubject: selectedFolderSubject,
        useCase: snippetUseCase
    )
            
    lazy var snippetPlusButtonViewModel = SnippetPlusButtonViewModel(
        controllSubject: controllerSubject
    )
    
    lazy var snippetDeleteButtonViewModel = SnippetDeleteButtonViewModel(
        snippetUseCase: snippetUseCase,
        snippetSubject: snippetSubject
    )
    
    lazy var snippetMoveButtonViewModel = SnippetMoveButtonViewModel(
        snippetSubject: snippetSubject,
        snippetUseCase: snippetUseCase
    )
    
    lazy var snippetScrollViewModel = SnippetScrollViewModel(
        snippetUseCase: snippetUseCase,
        selectedFolderSubject: selectedFolderSubject,
        controllerSubject: controllerSubject,
        snippetSubject: snippetSubject
    )
    
    lazy var snippetCopyButtonViewModel = SnippetCopyButtonViewModel(
        snippetSubject: snippetSubject,
        serviceSubject: serviceSubject
    )
    
    func getSnippetEditorViewModel(snippet: Snippet? = nil) -> SnippetEditorViewModel{
        return SnippetEditorViewModel(
            subject: controllerSubject,
            selectedFolderSubject: selectedFolderSubject,
            useCase: snippetUseCase,
            snippet: snippet
        )
    }
    
    func getSnippetCardViewModel(snippet: Snippet) -> SnippetCardViewModel {
        if let cached = snippetCardViewModelCache[snippet.id] {
            return cached
        }

        let viewModel = SnippetCardViewModel(
            snippet: snippet,
            controllSubject: controllerSubject,
            snippetSubject: snippetSubject
        )
        snippetCardViewModelCache[snippet.id] = viewModel
        return viewModel
    }
    
    //MARK: - Folder
    lazy var createFolderViewModel = CreateFolderViewModel(
        useCase: folderUseCase,
        subject: controllerSubject
    )
    
    lazy var folderButtonViewModel = FolderButtonViewModel(
        folderSubject: folderSubject,
        geometrySubject: geometrySubject
    )
    
    lazy var folderDeleteButtonViewModel = FolderDeleteButtonViewModel(
        folderSubject: folderSubject,
        folderUseCase: folderUseCase,
    )
    
    lazy var editFolderViewModel = EditFolderViewModel(
        folderSubject: folderSubject,
        folderEditSubject: folderEditSubject
    )
    
    lazy var folderViewModel = FolderScrollViewModel(
        useCase: folderUseCase,
        selectedFolderSubject: selectedFolderSubject
    )
    
    func getRenameableButtonViewModel(folder: Folder) ->  FolderButtonContentViewModel{
        return FolderButtonContentViewModel(
            folder: folder,
            folderUseCase: folderUseCase,
            folderEditSubject: folderEditSubject,
            selectedFolderSubject: selectedFolderSubject
        )
    }
    
    //MARK: - else
    lazy var panelHeaderViewModel = PanelHeaderViewModel(
        controllerSubject: controllerSubject
    )
    
    lazy var appMenuBarViewModel = AppMenuBarViewModel(
        controllerSubject: controllerSubject
    )
    
}
