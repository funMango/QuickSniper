//
//  NoteEditorViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 5/22/25.
//

import Foundation
import Combine

class NoteEditorViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var content: String = ""
    private var controllSubject: PassthroughSubject<ControllerMessage, Never>
    private var selectedFolderSubject: CurrentValueSubject<Folder?, Never>
    private var useCase: SnippetUseCase
    private var selectedFolder: Folder?
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        title: String = "",
        content: String = "",
        subject: PassthroughSubject<ControllerMessage, Never>,
        selectedFolderSubject: CurrentValueSubject<Folder?, Never>,
        useCase: SnippetUseCase
    ) {
        self.title = title
        self.content = content
        self.controllSubject = subject
        self.selectedFolderSubject = selectedFolderSubject
        self.useCase = useCase
        
        setupSelectedFolderBindings()
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
        controllSubject.send(.hideNoteEditorView)
    }
    
    private func setupSelectedFolderBindings() {
        selectedFolderSubject
            .sink { [weak self] folder in
                self?.selectedFolder = folder
            }
            .store(in: &cancellables)
    }
}
