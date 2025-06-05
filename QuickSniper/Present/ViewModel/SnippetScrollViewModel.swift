//
//  SnippetScrollViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 5/30/25.
//

import Foundation
import Combine
import SwiftUI


final class SnippetScrollViewModel: ObservableObject {
    @Published var snippets: [Snippet] = []
    @Published private var allSnippets: [Snippet] = []
    @Published private var selectedFolder: Folder?
        
    private var snippetUseCase: SnippetUseCase
    private var selectedFolderSubject: CurrentValueSubject<Folder?, Never>    
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        snippetUseCase: SnippetUseCase,
        selectedFolderSubject: CurrentValueSubject<Folder?, Never>,
    ) {
        self.snippetUseCase = snippetUseCase
        self.selectedFolderSubject = selectedFolderSubject
        setupSelectedFolderBindings()
    }
    
    func getSnippets(_ snippets: [Snippet]) {
        DispatchQueue.main.async { [weak self] in
            self?.allSnippets = snippets
        }
    }
    
    func updateSnippets() {
        for (i, s) in snippets.enumerated() {
            s.order = i
        }
        
        do {
            try self.snippetUseCase.updateAllSnippets(snippets)
        } catch {
            print("[ERROR]: SnippetScrollViewModel-handleSwitchOrder \(error)")
        }
    }
    
    func removeAllSnippets() {
        do {
            for s in snippets {
                try self.snippetUseCase.deleteSnippet(s)
            }
        } catch {
            
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
                        self?.snippets = allSnippets
                                            .filter { $0.folderId == folder.id }
                                            .sorted { $0.order < $1.order }
                    } else {
                        self?.snippets = []
                    }
                }
            }
            .store(in: &cancellables)
    }
}
