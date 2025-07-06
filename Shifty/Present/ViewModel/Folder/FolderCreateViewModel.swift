//
//  CreateFolderViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 5/26/25.
//

import Foundation
import Combine
import Resolver

final class FolderCreateViewModel: ObservableObject {
    @Published var folderName: String    
    @Published var selectedFolderType: FolderType = .snippet
    private var useCase: FolderUseCase
    @Injected var controllSubject: PassthroughSubject<ControllerMessage, Never>
    @Injected var folderSubject: CurrentValueSubject<FolderMessage?, Never>
    
    init(
        folderName: String = "",
        useCase: FolderUseCase,
    ) {
        self.folderName = folderName
        self.useCase = useCase
    }
        
    func selectFolderType(_ type: FolderType) {
        self.selectedFolderType = type
    }
    
    func goNextPage() {        
        switch selectedFolderType {
        case .snippet:
            controllSubject.send(.openSnippetEditor)
        case .fileBookmark:
            controllSubject.send(.openFileBookmarkCreateView)
        default:
            break
        }
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
                self?.folderSubject.send(.switchCurrentFolder(newFolder))
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
