//
//  RenameableButtonViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 5/29/25.
//

import Foundation
import Combine

final class FolderButtonContentViewModel: ObservableObject {
    @Published var hoverFolder: Folder?
    @Published var buttonText: String = ""
    @Published var isRenaming: Bool = false
    var folder: Folder
    private var folderUseCase: FolderUseCase
    private var folderEditSubject: CurrentValueSubject<Folder?, Never>
    private var selectedFolderSubject: CurrentValueSubject<Folder?, Never>
    private var cancellables = Set<AnyCancellable>()
        
    init(
        folder: Folder,
        folderUseCase: FolderUseCase,
        folderEditSubject: CurrentValueSubject<Folder?, Never>,
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
        
        /// 메인 스레드에서 update해야 UI충돌이 나지 않음
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            do {
                try self.folderUseCase.updateFolder(folder)
            } catch {
                print("[ERROR]: folder name update error: \(error)")
            }
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
    
    private func isSameFolder(_ target: Folder?) -> Bool {
        if let target = target {
            return target.id == folder.id
        }
        return false        
    }    
}
