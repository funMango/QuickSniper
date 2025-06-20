//
//  EditFolderViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 5/28/25.
//

import Foundation
import Combine

class FolderEditViewModel: ObservableObject, FolderSubjectBindable {
    var selectedFolder: Folder?
    var selectedFolderSubject: CurrentValueSubject<Folder?, Never>
    var folderEditSubject: PassthroughSubject<Folder, Never>
    var cancellables = Set<AnyCancellable>()
        
    init(
        selectedFolderSubject: CurrentValueSubject<Folder?, Never>,
        folderEditSubject: PassthroughSubject<Folder, Never>
    ) {
        self.selectedFolderSubject = selectedFolderSubject
        self.folderEditSubject = folderEditSubject
        setupSelectedFolderBindings()
    }
    
    func folderEdit() {
        guard let selectedFolder = selectedFolder else {
            print("folder is nil")
            return
        }
        
        folderEditSubject.send(selectedFolder)
    }    
}
