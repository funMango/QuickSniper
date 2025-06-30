//
//  SnippetPlusButtonViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 6/2/25.
//

import Foundation
import Combine

final class ItemPlusButtonViewModel: ObservableObject, FolderSubjectBindable {
    var selectedFolder: Folder?
    
    var controllSubject: PassthroughSubject<ControllerMessage, Never>
    var selectedFolderSubject: CurrentValueSubject<Folder?, Never>
    var cancellables = Set<AnyCancellable>()
        
    init(
        controllSubject: PassthroughSubject<ControllerMessage, Never>,
        selectedFolderSubject: CurrentValueSubject<Folder?, Never>
    ) {
        self.controllSubject = controllSubject
        self.selectedFolderSubject = selectedFolderSubject
        setupSelectedFolderBindings()
    }
            
    func openItemEditor() {
        guard let selectedFolder = self.selectedFolder else { return }
        
        switch selectedFolder.type {
        case .snippet:
            controllSubject.send(.openSnippetEditor)
        case .fileBookmark:
            controllSubject.send(.openFileBookmarkCreateView)
        default:
            break
        }
    }
}
