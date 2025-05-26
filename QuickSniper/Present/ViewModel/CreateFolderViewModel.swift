//
//  CreateFolderViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 5/26/25.
//

import Foundation
import Resolver

final class CreateFolderViewModel: ObservableObject {
    @Published var folderName: String
    @Published var folderType: FolderType
    @Injected var container: ControllerContainer
    private var useCase: FolderUseCase
    
    init(folderName: String = "", folderType: FolderType = .snippet, useCase: FolderUseCase) {
        self.folderName = folderName
        self.folderType = folderType
        self.useCase = useCase
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
        container.createFolderController.hide()
    }
    
    private func reset() {
        folderName = ""
        folderType = .snippet
    }
}
