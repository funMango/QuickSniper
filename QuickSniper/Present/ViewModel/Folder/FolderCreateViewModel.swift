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
    private var subject: PassthroughSubject<ControllerMessage, Never>
    
    init(
        folderName: String = "",
        useCase: FolderUseCase,
        subject:PassthroughSubject<ControllerMessage, Never>
    ) {
        self.folderName = folderName
        self.useCase = useCase
        self.subject = subject
    }
        
    func selectFolderType(_ type: FolderType) {
        self.selectedFolderType = type
    }
    
    func createFolder() {
        do {
            try useCase.createFolder(name: folderName, type: selectedFolderType)
            reset()
            hide()
        } catch {
            print("[Error]: \(error)")
        }
    }
    
    func hide() {
        subject.send(.escapePressed)
    }
    
    private func reset() {
        folderName = ""
        selectedFolderType = .snippet
    }
}
