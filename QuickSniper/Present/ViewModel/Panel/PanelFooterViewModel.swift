//
//  PanelFooterViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 6/14/25.
//

import Foundation
import Combine

final class PanelFooterViewModel: FolderBindableViewModel {
    @Published var localShortcuts = [LocalShortcut]()
    
    override init(selectedFolderSubject: CurrentValueSubject<Folder?, Never>) {
        super.init(selectedFolderSubject: selectedFolderSubject)
        setupSelectedFolderBindings()
    }
        
    override func setupSelectedFolderBindings() {
        selectedFolderSubject
            .sink { [weak self] folder in
                guard let self = self else { return }
                                
                self.selectedFolder = folder
                self.localShortcuts = self.selectedFolder?.type.getMyShortcuts() ?? []                
            }
            .store(in: &cancellables)
    }
}
