//
//  NoteEditorViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 5/22/25.
//

import Foundation
import Combine

class SnippetEditorViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var content: String = ""
    @Published var isEditing = false
    private var controllSubject: PassthroughSubject<ControllerMessage, Never>
    private var selectedFolderSubject: CurrentValueSubject<Folder?, Never>
    private var coreModelSubject: CurrentValueSubject<CoreModelMessage?, Never>
    private var snippetUseCase: SnippetUseCase
    private var coreModelUseCase: CoreModelUseCase
    private var selectedFolder: Folder?
    private var cancellables: Set<AnyCancellable> = []
    private var snippet: Snippet?
    
    init(
        title: String = "",
        content: String = "",
        subject: PassthroughSubject<ControllerMessage, Never>,
        selectedFolderSubject: CurrentValueSubject<Folder?, Never>,
        coreModelSubject: CurrentValueSubject<CoreModelMessage?, Never>,
        snippetUseCase: SnippetUseCase,
        coreModelUseCase: CoreModelUseCase,
        snippet: Snippet? = nil
    ) {
        
        self.title = title
        self.content = content
        self.controllSubject = subject
        self.selectedFolderSubject = selectedFolderSubject
        self.coreModelSubject = coreModelSubject
        self.snippetUseCase = snippetUseCase
        self.coreModelUseCase = coreModelUseCase
        self.snippet = snippet
        
        resetSnippet()
        setupSelectedFolderBindings()
        setupInitialSnippet()
    }
    
    // MARK: - Main Function
    func save() {                
        if let snippet = snippet  {
            do {
                try snippetUseCase.updateSnippet(getUpdateSnippet(from: snippet))
                DispatchQueue.main.async { [weak self] in
                    self?.coreModelSubject.send(.updated)
                }
            } catch {
                print()
            }
        } else {
            if let snippet = getSnippet() {
                coreModelUseCase.save(snippet)
                DispatchQueue.main.async { [weak self] in
                    self?.coreModelSubject.send(.updated)
                }
            }
        }
        
        DispatchQueue.main.async { [weak self] in            
            self?.hide()
        }
    }
    
    func prev() {
        controllSubject.send(.openCreateFolderView)
    }
    
    func hide() {
        controllSubject.send(.escapePressed)
    }
    
    // MARK: - Sub Function
    private func getSnippet() -> Snippet? {
        guard let selectedFolder = selectedFolder else {
            print("[ERROR]: NoteEditorViewModel - save")
            return nil
        }
        
        return Snippet(
            folderId: selectedFolder.id,
            title: title,
            body: content,
            order: 0
        )
    }
    
    private func getUpdateSnippet(from snippet: Snippet) -> Snippet {
        return Snippet(
            id: snippet.id,
            folderId: snippet.folderId,
            title: title,
            body: content,
            order: snippet.order
        )
    }
    
    private func resetSnippet() {
        self.title = ""
        self.content = ""
        self.isEditing = false
        self.snippet = nil
    }
    
    private func setupInitialSnippet() {
        if let snippet = snippet {
            self.isEditing = true
            self.title = snippet.title
            self.content = snippet.body
        }
    }
    
    private func setupSelectedFolderBindings() {
        selectedFolderSubject
            .sink { [weak self] folder in
                self?.selectedFolder = folder
            }
            .store(in: &cancellables)
    }
}
