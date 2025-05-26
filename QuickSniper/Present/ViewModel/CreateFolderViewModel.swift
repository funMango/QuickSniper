//
//  CreateFolderViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 5/26/25.
//

import Foundation
import Combine

final class CreateFolderViewModel: ObservableObject {
    @Published var folderName: String
    @Published var folderType: FolderType
    private var useCase: FolderUseCase
    private var subject: PassthroughSubject<ControllerMessage, Never>
    
    init(
        folderName: String = "",
        folderType: FolderType = .snippet,
        useCase: FolderUseCase,
        subject:PassthroughSubject<ControllerMessage, Never>
    ) {
        self.folderName = folderName
        self.folderType = folderType
        self.useCase = useCase
        self.subject = subject
    }
    
    func createFolder() {
        do {
            try useCase.createFolder(name: folderName, type: folderType)
            reset()
            hide()
        } catch {
            print("[Error]: \(error)")
        }
    }
    
    func hide() {
        subject.send(.hideCreateFolderView)
    }
    
    private func reset() {
        folderName = ""
        folderType = .snippet
    }
}
