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
    private let vmPassSubject: PassthroughSubject<VmPassMessage, Never>
    private let folderSubject: CurrentValueSubject<Folder?, Never>
    private let folderEditSubject: CurrentValueSubject<Folder?, Never>
    private let selectedFolderSubject: CurrentValueSubject<Folder?, Never>
    private let folderMessageSubject: CurrentValueSubject<FolderMessage?, Never>
    private let snippetSubject: CurrentValueSubject<SnippetMessage?, Never>
    private let serviceSubject: CurrentValueSubject<ServiceMessage?, Never>
    private let hotCornerSubject: CurrentValueSubject<HotCornerMessage?, Never>
    private let fileBookmarkSubject: CurrentValueSubject<FileBookmarkMessage?, Never>
    
    private var snippetCardViewModelCache: [String: SnippetCardViewModel] = [:]
    
    private lazy var folderRepository = DefaultFolderRepository(context: modelContext)
    private lazy var snippetRepository = DefaultSnippetRepository(context: modelContext)
    private lazy var userRepository = DefaultUserRepository(context: modelContext)
    private lazy var fileBookmarkRepository = DefaultFileBookmarkRepository(context: modelContext)
    
    private lazy var folderUseCase = DefaultFolderUseCase(repository: folderRepository)
    private lazy var snippetUseCase = DefaultSnippetUseCase(repository: snippetRepository)
    private lazy var userUseCase = DefaultUserUserCase(repository: userRepository)
    private lazy var fileBookmarkUseCase = DefaultFileBookmarkUseCase(repository: fileBookmarkRepository)
            
    init(
        modelContext: ModelContext,
        controllerSubject: PassthroughSubject<ControllerMessage, Never>,
        vmPassSubject: PassthroughSubject<VmPassMessage, Never>,
        folderSubject: CurrentValueSubject<Folder?, Never>,
        folderEditSubject:CurrentValueSubject<Folder?, Never>,
        selectedFolderSubject: CurrentValueSubject<Folder?, Never>,
        folderMessageSubject: CurrentValueSubject<FolderMessage?, Never>,
        snippetSubject: CurrentValueSubject<SnippetMessage?, Never>,
        serviceSubject: CurrentValueSubject<ServiceMessage?, Never>,
        hotCornerSubject: CurrentValueSubject<HotCornerMessage?, Never>,
        fileBookmarkSubject: CurrentValueSubject<FileBookmarkMessage?, Never>
    ){
        self.modelContext = modelContext
        self.controllerSubject = controllerSubject
        self.vmPassSubject = vmPassSubject        
        self.folderSubject = folderSubject
        self.folderEditSubject = folderEditSubject
        self.selectedFolderSubject = selectedFolderSubject
        self.folderMessageSubject = folderMessageSubject
        self.snippetSubject = snippetSubject
        self.serviceSubject = serviceSubject
        self.hotCornerSubject = hotCornerSubject
        self.fileBookmarkSubject = fileBookmarkSubject
    }
    
    //MARK: - Snippet
    lazy var snippetEditorViewModel = SnippetEditorViewModel(
        subject: controllerSubject,
        selectedFolderSubject: selectedFolderSubject,
        useCase: snippetUseCase
    )
            
    lazy var itemPlusButtonViewModel = ItemPlusButtonViewModel(
        controllSubject: controllerSubject,
        selectedFolderSubject: selectedFolderSubject
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
        snippetSubject: snippetSubject,
        folderMessageSubject: folderMessageSubject
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
            snippetSubject: snippetSubject,
            selectedFolderSubject: selectedFolderSubject
        )
        snippetCardViewModelCache[snippet.id] = viewModel
        return viewModel
    }
    
    //MARK: - Folder
    lazy var createFolderViewModel = FolderCreateViewModel(
        useCase: folderUseCase,
        controllSubject: controllerSubject,
        selectedFolderSubject: selectedFolderSubject
    )
    
    lazy var folderCreateButtonViewModel = FolderCreateButtonViewModel(
        controllerSubject: controllerSubject,
        selectedFolderSubject: selectedFolderSubject,
        folderEditSubject: folderEditSubject,
        folderUsecase: folderUseCase
    )
    
    lazy var folderDeleteButtonViewModel = FolderDeleteButtonViewModel(
        selectedFolderSubject: selectedFolderSubject,
        folderMessageSubject: folderMessageSubject,
        controllSubject: controllerSubject,
        folderUseCase: folderUseCase,
    )
    
    lazy var editFolderViewModel = FolderEditViewModel(
        selectedFolderSubject: selectedFolderSubject,
        folderEditSubject: folderEditSubject
    )
    
    lazy var folderViewModel = FolderScrollViewModel(
        folderUsecase: folderUseCase,
        selectedFolderSubject: selectedFolderSubject,
        folderMessageSubject: folderMessageSubject
    )
    
    func getFolderButtonViewModel(folder: Folder) -> FolderButtonViewModel {
        return FolderButtonViewModel(
            folder: folder,
            selectedFolderSubject: selectedFolderSubject,
            folderEditSubject: folderEditSubject
        )
    }
    
    func getFolderButtonContentViewModel(folder: Folder) ->  FolderButtonContentViewModel{
        return FolderButtonContentViewModel(
            folder: folder,
            folderUseCase: folderUseCase,
            folderEditSubject: folderEditSubject,
            selectedFolderSubject: selectedFolderSubject
        )
    }
    
    //MARK: Panel
    lazy var panelHeaderViewModel = PanelHeaderViewModel(
        controllerSubject: controllerSubject
    )
    
    lazy var panelFooterViewModel = PanelFooterViewModel(
        selectedFolderSubject: selectedFolderSubject
    )
    
    //MARK: FileBookmark
    lazy var fileBookmarkListViewModel = FileBookmarkListViewModel(
        usecase: fileBookmarkUseCase,
        controllSubject: controllerSubject,
        vmPassSubject: vmPassSubject,
        selectedFolderSubject: selectedFolderSubject
    )
    
    lazy var fileBookmarkCreateViewModel = FileBookmarkCreateViewModel(
        controllSubject: controllerSubject,
        vmPassSubject: vmPassSubject
    )
    
    lazy var fileBookmarkScrollViewModel = FileBookmarkScrollViewModel(
        usecase: fileBookmarkUseCase,
        controllSubject: controllerSubject,
        selectedFolderSubject: selectedFolderSubject,
        fileBookmarkSubject: fileBookmarkSubject,
        folderMessageSubject: folderMessageSubject
    )
    
    lazy var fileBookmarkDeleteButtonViewModel = FileBookmarkDeleteButtonViewModel(
        usecase: fileBookmarkUseCase,
        fileBookmarkSubject: fileBookmarkSubject
    )
    
    lazy var fileBookmarkMoveButtonViewModel = FileBookmarkMoveButtonViewModel(
        usecase: fileBookmarkUseCase,
        fileBookmarkSubject: fileBookmarkSubject
    )
            
    func getFileBookmarkRowViewModel(item: FileBookmarkItem) -> FileBookmarkRowViewModel{
        FileBookmarkRowViewModel(
            item: item,
            vmPassSubject: vmPassSubject
        )
    }
    
    func getFileBookmarkCardViewModel(item: FileBookmarkItem) -> FileBookmarkCardViewModel{
        FileBookmarkCardViewModel(
            item: item,
            usecase: fileBookmarkUseCase,
            controllSubject: controllerSubject,
            fileBookmarkSubject: fileBookmarkSubject,
            selectedFolderSubject: selectedFolderSubject
        )
    }
    
    //MARK: - CoreModel
    lazy var coreModelScrollViewModel = CoreModelScrollViewModel(
        controllSubject: controllerSubject
    )
            
    //MARK: - else
    lazy var appMenuBarViewModel = AppMenuBarViewModel(
        controllerSubject: controllerSubject
    )
    
    lazy var hotCornerSettingViewModel = HotCornerSettingViewModel(
        hotCornerSubject: hotCornerSubject
    )
    
    lazy var itemScrollViewModel = ItemScrollViewModel(
        selectedFolderSubject: selectedFolderSubject
    )
    
    lazy var subscriptionViewModel = SubscriptionViewModel(
        controllSubject: controllerSubject
    )
    
    lazy var panelViewModel = PanelViewModel(
        userUseCase: userUseCase,
        folderUseCase: folderUseCase,
        snippetUseCase: snippetUseCase,
        serviceSubject: serviceSubject,
        hotCornerSubject: hotCornerSubject
    )
}
