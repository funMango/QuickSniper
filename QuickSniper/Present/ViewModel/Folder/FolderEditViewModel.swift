//
//  EditFolderViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 5/28/25.
//

import Foundation
import Combine

class FolderEditViewModel: ObservableObject {
    private var folderSubject: CurrentValueSubject<Folder?, Never>
    private var folderEditSubject: PassthroughSubject<Folder, Never>
    private var cancellables = Set<AnyCancellable>()
    private var folder: Folder?
    
    init(
        folderSubject: CurrentValueSubject<Folder?, Never>,
        folderEditSubject: PassthroughSubject<Folder, Never>
    ) {
        self.folderSubject = folderSubject
        self.folderEditSubject = folderEditSubject
        setupBindings()
    }
    
    func folderEdit() {
        guard let folder = folder else {
            print("folder is nil")
            return
        }
        
        folderEditSubject.send(folder)
    }
    
    private func setupBindings() {
        folderSubject
            .sink { [weak self] folder in
                self?.folder = folder
            }
            .store(in: &cancellables)
    }
}
