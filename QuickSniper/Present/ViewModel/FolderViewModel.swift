//
//  FolderViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 5/29/25.
//

import Foundation
import Combine

final class FolderViewModel: ObservableObject {
    @Published var selectedFolder: Folder?
    private var useCase: FolderUseCase
    private var selectedFolderSubject: CurrentValueSubject<Folder?, Never>
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        useCase: FolderUseCase,
        selectedFolderSubject: CurrentValueSubject<Folder?, Never>
    ){
        self.useCase = useCase
        self.selectedFolderSubject = selectedFolderSubject
        setSelectedFolder()
        setupSelectedFolderBindings()
    }
    
    private func setSelectedFolder() {
        do {
            let folder = try useCase.getFirstFolder()
            self.selectedFolder = folder
            selectedFolderSubject.send(folder)
        } catch {
            print("[ERROR]: FolderViewModel - setSelectedFolder: \(error)")
        }
    }
    
    private func setupSelectedFolderBindings() {
        selectedFolderSubject
            .sink { [weak self] folder in
                self?.selectedFolder = folder
            }
            .store(in: &cancellables)
    }
}
