//
//  RenameableButtonViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 5/29/25.
//

import Foundation
import Combine

final class RenameableButtonViewModel: ObservableObject {
    @Published var hoverFolder: Folder?
    @Published var buttonText: String = ""
    @Published var isRenaming: Bool = false
        
    private var folderUseCase: FolderUseCase
    private var folderEditSubject: PassthroughSubject<Folder, Never>
    private var selectedFolderSubject: CurrentValueSubject<Folder?, Never>
    private var cancellables = Set<AnyCancellable>()
    var folder: Folder
    
    init(
        folder: Folder,
        folderUseCase: FolderUseCase,
        folderEditSubject: PassthroughSubject<Folder, Never>,
        selectedFolderSubject: CurrentValueSubject<Folder?, Never>
    ) {
        self.folder = folder
        self.buttonText = folder.name
        self.folderUseCase = folderUseCase
        self.folderEditSubject = folderEditSubject
        self.selectedFolderSubject = selectedFolderSubject
        setupBindings()
    }
    
    func cancelRenaming() {
        self.isRenaming = false
    }
    
    func selectFolder() {
        selectedFolderSubject.send(folder)
    }
    
    func updateFolderName() {
        folder.changeName(buttonText)
        do {
            try folderUseCase.updateFolder(folder)
        } catch {
            print("[ERROR]: folder name update error: \(error)")
        }
    }
    
    private func setupBindings() {
        folderEditSubject
            .sink { [weak self] folder in
                if self?.isSameFolder(folder) == true {                    
                    self?.isRenaming = true
                }
            }
            .store(in: &cancellables)
    }
    
    private func isSameFolder(_ target: Folder) -> Bool {
        return target.id == folder.id
    }    
}
