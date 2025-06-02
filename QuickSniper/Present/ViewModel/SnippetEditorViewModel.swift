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
        
        useCase.createSnippet(
            folderId: selectedFolder.id,
            title: title,
            body: content
        )
        
        hide()
    }
    
    func hide() {        
        controllSubject.send(.hideSnippetEditorView)        
    }
    
    private func resetSnippet() {
        self.title = ""
        self.content = ""
    }
    
    private func setupInitialSnippet() {
        print("snippet Editor ViewModel 초기화")
        
        if let snippet = snippet {
            print("snippet is not nil")
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
