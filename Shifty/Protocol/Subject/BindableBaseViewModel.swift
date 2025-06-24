//
//  BindableBaseViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 6/15/25.
//

import Foundation
import Combine

class FolderBindableViewModel: ObservableObject, FolderSubjectBindable {
    @Published var selectedFolder: Folder?
    
    let selectedFolderSubject: CurrentValueSubject<Folder?, Never>
    var cancellables: Set<AnyCancellable> = []
    
    init(selectedFolderSubject: CurrentValueSubject<Folder?, Never>) {
        self.selectedFolderSubject = selectedFolderSubject
    }
    
    func setupSelectedFolderBindings() {
        selectedFolderSubject
            .sink { [weak self] folder in
                self?.selectedFolder = folder
            }
            .store(in: &cancellables)
    }
}
