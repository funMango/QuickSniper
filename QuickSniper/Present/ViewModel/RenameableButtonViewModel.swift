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
    private var folderEditSubject: CurrentValueSubject<Folder?, Never>
    private var cancellables = Set<AnyCancellable>()
    var folder: Folder
    
    init(
        folder: Folder,
        folderUseCase: FolderUseCase,
        folderEditSubject: CurrentValueSubject<Folder?, Never>
    ) {
        self.folder = folder
        self.buttonText = folder.name
        self.folderUseCase = folderUseCase
        self.folderEditSubject = folderEditSubject
        setupBindings()
    }
    
    func toggleRenaming() {
        self.isRenaming.toggle()
    }
    
    private func setupBindings() {
        folderEditSubject
            .sink { [weak self] folder in
                guard let folder = folder else { return }
                
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
