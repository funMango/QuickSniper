//
//  SnippetPlusButtonViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 6/2/25.
//

import Foundation
import Combine

final class ItemPlusButtonViewModel: FolderBindableViewModel {
    private var controllSubject: PassthroughSubject<ControllerMessage, Never>
    
    init(
        controllSubject: PassthroughSubject<ControllerMessage, Never>,
        selectedFolderSubject: CurrentValueSubject<Folder?, Never>
    ) {
        self.controllSubject = controllSubject
        super.init(selectedFolderSubject: selectedFolderSubject)
        setupSelectedFolderBindings()
    }
            
    func openItemEditor() {
        guard let selectedFolder = self.selectedFolder else { return }
        
        switch selectedFolder.type {
        case .snippet:
            controllSubject.send(.openSnippetEditor)
        }
    }
}
