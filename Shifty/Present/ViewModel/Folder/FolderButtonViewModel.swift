//
//  FolderButtonViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 5/27/25.
//

import Foundation
import Combine

final class FolderButtonViewModel: ObservableObject, FolderSubjectBindable {
    @Published var selectedFolder: Folder?
    @Published var isSelected: Bool = false
    var folder: Folder
    var selectedFolderSubject: CurrentValueSubject<Folder?, Never>
    var folderEditSubject: CurrentValueSubject<Folder?, Never>
    var cancellables: Set<AnyCancellable> = []
    
    init(
        folder: Folder,
        selectedFolderSubject: CurrentValueSubject<Folder?, Never>,
        folderEditSubject: CurrentValueSubject<Folder?, Never>
    ) {
        self.folder = folder
        self.selectedFolderSubject = selectedFolderSubject
        self.folderEditSubject = folderEditSubject
        setupSelectedFolderBindings()
    }        
    
    func setupSelectedFolderBindings() {
        selectedFolderSubject
            .sink { [weak self] folder in
                guard let self = self else { return }
                self.selectedFolder = folder
                self.isSelected = self.selectedFolder?.id == self.folder.id
            }
            .store(in: &cancellables)
    }
            
    func changeSelectedFolder() {
        selectedFolderSubject.send(folder)
    }
}
