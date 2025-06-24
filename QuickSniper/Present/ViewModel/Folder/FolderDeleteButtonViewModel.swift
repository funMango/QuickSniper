//
//  DeleteFolderViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 5/27/25.
//

import Foundation
import Combine

final class FolderDeleteButtonViewModel: ObservableObject, FolderSubjectBindable, ControllSubjectBindable {
    
    
    var selectedFolder: Folder?
    var selectedFolderSubject: CurrentValueSubject<Folder?, Never>
    var folderMessageSubject: CurrentValueSubject<FolderMessage?, Never>
    var controllSubject: PassthroughSubject<ControllerMessage, Never>
    var folderUseCase: FolderUseCase
    var cancellables: Set<AnyCancellable> = []
    
    init(
        
        selectedFolderSubject: CurrentValueSubject<Folder?, Never>,
        folderMessageSubject: CurrentValueSubject<FolderMessage?, Never>,
        controllSubject: PassthroughSubject<ControllerMessage, Never>,
        folderUseCase: FolderUseCase,
    ) {
        self.selectedFolderSubject = selectedFolderSubject
        self.folderMessageSubject = folderMessageSubject
        self.controllSubject = controllSubject
        self.folderUseCase = folderUseCase
        setupSelectedFolderBindings()
    }
    
    func deleteFolder() {
        guard let selectedfolder = selectedFolder else {
            return
        }
        
        do {
            try self.folderUseCase.deleteFolder(selectedfolder)
        } catch {
            print("[Error] deleteFolder error:" + error.localizedDescription)
        }
                
        DispatchQueue.main.async { [weak self] in
            self?.folderMessageSubject.send(.deleteFolderItems(selectedfolder.id))
        }
    }   
}

extension FolderDeleteButtonViewModel {
    func showDeleteFolderAlert() {
        AlertManager.showTwoButtonAlert(
            messageText: "deleteFolderConfirm",
            informativeText: "deleteFolderWarning",
            confirmButtonText: "delete",
            onConfirm: {
                deleteFolder()
            },
            onCancel: { [weak self] in
                self?.controllSubject.send(.openPanel)
            }
        )
    }
}
