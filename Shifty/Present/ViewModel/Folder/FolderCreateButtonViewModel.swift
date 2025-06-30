//
//  FolderCreateButtonViewModel.swift
//  Shifty
//
//  Created by 이민호 on 6/30/25.
//

import Foundation
import Combine

final class FolderCreateButtonViewModel: ObservableObject, FolderSubjectBindable {
    var folderUsecase: FolderUseCase
    var selectedFolderSubject: CurrentValueSubject<Folder?, Never>
    var folderEditSubject: CurrentValueSubject<Folder?, Never>
    var selectedFolder: Folder?
    var cancellables: Set<AnyCancellable> = []
    
    init(selectedFolderSubject: CurrentValueSubject<Folder?, Never>,
         folderEditSubject: CurrentValueSubject<Folder?, Never>,
         folderUsecase: FolderUseCase) {
        self.selectedFolderSubject = selectedFolderSubject
        self.folderEditSubject = folderEditSubject
        self.folderUsecase = folderUsecase
    }
    
    func createFolder() {
        do {
            let newFolder = Folder(
                name: "",
                type: .all,
                order: 0
            )
            try folderUsecase.createFolder(newFolder)
            
            DispatchQueue.main.async { [weak self] in
                self?.selectedFolderSubject.send(newFolder)
                self?.folderEditSubject.send(newFolder)
            }
        } catch {
            print("[Error]: \(error)")
        }
    }
}
