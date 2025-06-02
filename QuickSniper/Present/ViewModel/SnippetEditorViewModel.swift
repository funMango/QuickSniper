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
    private var controllSubject: PassthroughSubject<ControllerMessage, Never>
    private var selectedFolderSubject: CurrentValueSubject<Folder?, Never>
    private var useCase: SnippetUseCase
    private var selectedFolder: Folder?
    private var cancellables: Set<AnyCancellable> = []
    private var snippet: Snippet?
    
    init(
        title: String = "",
        content: String = "",
        subject: PassthroughSubject<ControllerMessage, Never>,
        selectedFolderSubject: CurrentValueSubject<Folder?, Never>,
        useCase: SnippetUseCase,
        snippet: Snippet? = nil
    ) {
        self.title = title
        self.content = content
        self.controllSubject = subject
        self.selectedFolderSubject = selectedFolderSubject
        self.useCase = useCase
        self.snippet = snippet
        
        setupSelectedFolderBindings()
        setupInitialSnippet()
    }
    
    func save() {
        guard let selectedFolder = selectedFolder else {
            print("[ERROR]: NoteEditorViewModel - save")
            return
        }
        
        if let snippet = snippet  {
            do {
                try useCase.updateFolder(getUpdateSnippet(from: snippet))
            } catch {
                print()
            }
        } else {
            useCase.createSnippet(
                folderId: selectedFolder.id,
                title: title,
                body: content
            )
        }
        resetSnippet()
        hide()
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
    
    func hide() {
        controllSubject.send(.hideSnippetEditorView)        
    }
    
    private func resetSnippet() {
        self.title = ""
        self.content = ""
        self.snippet = nil
    }
    
    private func setupInitialSnippet() {
        if let snippet = snippet {
            self.snippet = snippet
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
