//
//  RenameableButtonViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 5/29/25.
//

import Foundation
import Combine
import Resolver

final class FolderButtonContentViewModel: ObservableObject {    
    @Published var buttonText: String = ""
    @Published var isRenaming: Bool = false
    @Injected var folderSubject: CurrentValueSubject<FolderMessage?, Never>
    
    var folder: Folder
    private var folderUseCase: FolderUseCase
    private var folderEditSubject: CurrentValueSubject<Folder?, Never>
    private var cancellables = Set<AnyCancellable>()
        
    init(
        folder: Folder,
        folderUseCase: FolderUseCase,
        folderEditSubject: CurrentValueSubject<Folder?, Never>,
    ) {
        self.folder = folder
        self.buttonText = folder.name
        self.folderUseCase = folderUseCase
        self.folderEditSubject = folderEditSubject
        
        setupBindings()
    }
    
    func cancelRenaming() {
        self.isRenaming = false
    }
    
    func selectFolder() {
        folderSubject.send(.switchCurrentFolder(folder))
    }
    
    /// 메인 스레드에서 update해야 UI충돌이 나지 않음
    @MainActor
    func updateFolderName() {
        folder.changeName(buttonText)
            
        do {
            try self.folderUseCase.updateFolder(folder)
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
    
    private func isSameFolder(_ target: Folder?) -> Bool {
        if let target = target {
            return target.id == folder.id
        }
        return false        
    }    
}
