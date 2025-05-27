//
//  DeleteFolderViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 5/27/25.
//

import Foundation
import Combine

final class DeleteFolderViewModel: ObservableObject {
    private var folderSubject: CurrentValueSubject<Folder?, Never>
    private var folderUseCase: FolderUseCase
    private var cancellables = Set<AnyCancellable>()
    private var folder: Folder?
    
    init(folderSubject: CurrentValueSubject<Folder?, Never>, folderUseCase: FolderUseCase) {
        self.folderSubject = folderSubject
        self.folderUseCase = folderUseCase
        setupBindings()
    }
    
    func deleteFolder() {
        guard let folder = folder else {            
            return
        }
        do {
            try folderUseCase.deleteFolder(folder)
        } catch {
            print("[Error] deleteFolder error:" + error.localizedDescription)
        }
    }
    
    private func setupBindings() {
        folderSubject
            .sink { [weak self] folder in
                self?.folder = folder
            }
            .store(in: &cancellables)
    }
}
