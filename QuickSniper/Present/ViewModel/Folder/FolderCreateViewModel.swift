//
//  CreateFolderViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 5/26/25.
//

import Foundation
import Combine

final class FolderCreateViewModel: ObservableObject {
    @Published var folderName: String    
    @Published var selectedFolderType: FolderType = .snippet
    private var useCase: FolderUseCase
    private var controllSubject: PassthroughSubject<ControllerMessage, Never>
    private var selectedFolderSubject: CurrentValueSubject<Folder?, Never>
    
    init(
        folderName: String = "",
        useCase: FolderUseCase,
        controllSubject:PassthroughSubject<ControllerMessage, Never>,
        selectedFolderSubject: CurrentValueSubject<Folder?, Never>
    ) {
        self.folderName = folderName
        self.useCase = useCase
        self.controllSubject = controllSubject
        self.selectedFolderSubject = selectedFolderSubject
    }
        
    func selectFolderType(_ type: FolderType) {
        self.selectedFolderType = type
    }
    
    func createFolder() {
        do {
            let newFolder = Folder(
                name: folderName,
                type: selectedFolderType,
                order: 0
            )
            try useCase.createFolder(newFolder)
            reset()
            hide()
            
            DispatchQueue.main.async { [weak self] in
                self?.selectedFolderSubject.send(newFolder)
            }
        } catch {
            print("[Error]: \(error)")
        }
    }
    
    func hide() {
        controllSubject.send(.escapePressed)
    }
    
    private func reset() {
        folderName = ""
        selectedFolderType = .snippet
    }
}
