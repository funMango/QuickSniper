//
//  FolderButtonViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 5/27/25.
//

import Foundation
import Combine
import Resolver

final class FolderButtonViewModel: ObservableObject {
    @Published var selectedFolder: Folder?
    @Published var isSelected: Bool = false
    @Injected var folderSubject: CurrentValueSubject<FolderMessage?, Never>
    
    var folder: Folder
    var cancellables: Set<AnyCancellable> = []
    
    init(folder: Folder) {
        self.folder = folder
               
        setupSelectedFolderBindings()
    }        
    
    func setupSelectedFolderBindings() {
        folderSubject
            .sink { [weak self] message in
                guard let self = self else { return }
                
                switch message {
                case .switchCurrentFolder(let folder):
                    self.selectedFolder = folder
                    self.isSelected = self.selectedFolder?.id == self.folder.id
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
            
    func changeSelectedFolder() {
        folderSubject.send(.switchCurrentFolder(folder))
    }
}
