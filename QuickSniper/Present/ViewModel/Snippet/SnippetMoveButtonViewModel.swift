//
//  SnippetMoveButtonViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 6/9/25.
//

import Foundation
import Combine

final class SnippetMoveButtonViewModel: ObservableObject, QuerySyncableObject {
    typealias Item = Folder
    @Published var items: [Item] = []
    @Published var allItems: [Item] = []
    @Published private var snippet: Snippet?
    
    private var snippetSubject: CurrentValueSubject<SnippetMessage?, Never>
    private var snippetUseCase: SnippetUseCase
    private var cancellables: Set<AnyCancellable> = []
    
    init(snippetSubject: CurrentValueSubject<SnippetMessage?, Never>, snippetUseCase: SnippetUseCase) {
        self.snippetSubject = snippetSubject
        self.snippetUseCase = snippetUseCase
        setUpHoveringSnippetBindings()
    }
    
    func getItems(_ items: [Item]) {
        DispatchQueue.main.async { [weak self] in
            self?.allItems = items
        }
    }
    
    func moveToFolder(_ folder: Item) {
        guard let snippet else { return }
        
        snippet.updateFolderId(folder.id)
        do {
            try snippetUseCase.updateSnippetFolder(snippet)
            DispatchQueue.main.async { [weak self] in
                self?.snippetSubject.send(.switchFolder)
            }
        } catch {
            print("[ERROR]: SnippetMoveButtonViewModel-moveToFolder \(error)")
        }
    }
    
    private func setUpHoveringSnippetBindings() {
        snippetSubject
            .sink { [weak self] message in
                switch message {
                case .snippetHovering(let snippet):
                    self?.snippet = snippet
                default:
                    break
                }
            }
            .store(in: &cancellables)
        
        Publishers.CombineLatest($allItems, $snippet)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] allFolders, snippet in
                guard snippet != nil else { return }
                let tagetFolder = allFolders.filter {$0.id == snippet?.folderId}.first
                self?.items = allFolders.filter {$0.id != snippet?.folderId }
                                       .filter {$0.type == tagetFolder?.type}
                                       .sorted { $0.order < $1.order }
            
            }
            .store(in: &cancellables)
    }
}
