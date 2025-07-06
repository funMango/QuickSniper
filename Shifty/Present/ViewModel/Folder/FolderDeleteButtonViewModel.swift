//
//  DeleteFolderViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 5/27/25.
//

import Foundation
import Combine
import Resolver

final class FolderDeleteButtonViewModel: ObservableObject, ControllSubjectBindable {
    @Injected var controllSubject: PassthroughSubject<ControllerMessage, Never>
    @Injected var folderSubject: CurrentValueSubject<FolderMessage?, Never>
    var selectedFolder: Folder?
    var folderUseCase: FolderUseCase
    var cancellables: Set<AnyCancellable> = []
    
    init(folderUseCase: FolderUseCase) {
        self.folderUseCase = folderUseCase
        folderMessageBindings()
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
            self?.folderSubject.send(.deleteFolderItems(selectedfolder.id))
        }
    }
    
    func folderMessageBindings() {
        folderSubject.sink { [weak self] message in
            switch message {
            case .switchCurrentFolder(let folder):
                self?.selectedFolder = folder
            default:
                break
            }
        }
        .store(in: &cancellables)
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
