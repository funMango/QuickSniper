//
//  EditFolderViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 5/28/25.
//

import Foundation
import Combine
import Resolver

class FolderEditViewModel: ObservableObject {
    var selectedFolder: Folder?
    @Injected var folderSubject: CurrentValueSubject<FolderMessage?, Never>
    
    var folderEditSubject: CurrentValueSubject<Folder?, Never>
    var cancellables = Set<AnyCancellable>()
        
    init(
        folderEditSubject: CurrentValueSubject<Folder?, Never>
    ) {
        self.folderEditSubject = folderEditSubject        
        folderMessageBindings()
    }
    
    func folderEdit() {
        guard let selectedFolder = selectedFolder else {
            print("folder is nil")
            return
        }
        
        folderEditSubject.send(selectedFolder)
    }
    
    func folderMessageBindings() {
        folderSubject
            .sink { [weak self] message in
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
