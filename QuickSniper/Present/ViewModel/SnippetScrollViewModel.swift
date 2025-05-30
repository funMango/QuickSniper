//
//  SnippetScrollViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 5/30/25.
//

import Foundation
import Combine


final class SnippetScrollViewModel: ObservableObject {
    @Published var snippets: [Snippet] = []
    @Published private var allSnippets: [Snippet] = []
    @Published private var selectedFolder: Folder?
        
    private var selectedFolderSubject: CurrentValueSubject<Folder?, Never>
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        selectedFolderSubject: CurrentValueSubject<Folder?, Never>
    ) {
        self.selectedFolderSubject = selectedFolderSubject
        setupSelectedFolderBindings()
    }
    
    func getSnippets(_ snippets: [Snippet]) {
        DispatchQueue.main.async { [weak self] in
            self?.allSnippets = snippets
        }
    }            
    
    private func setupSelectedFolderBindings() {
        selectedFolderSubject
            .assign(to: &$selectedFolder)
        
        Publishers.CombineLatest($allSnippets, $selectedFolder)
            .sink { [weak self] allSnippets, selectedFolder in
                guard selectedFolder != nil else { return }
                                                                       
                DispatchQueue.main.async { [weak self] in
                    if let folder = selectedFolder {
                        self?.snippets = allSnippets.filter { $0.folderId == folder.id }
                    } else {
                        self?.snippets = []
                    }
                }
            }
            .store(in: &cancellables)
    }
}
