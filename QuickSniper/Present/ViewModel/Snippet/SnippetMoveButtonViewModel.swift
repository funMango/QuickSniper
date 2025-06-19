//
//  SnippetMoveButtonViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 6/9/25.
//

import Foundation
import Combine

final class SnippetMoveButtonViewModel: ObservableObject, QuerySyncableObject, FolderMovable {
    typealias Item = Folder
    typealias MovableItem = Snippet  // FolderMovable용 타입 지정
    
    @Published var items: [Item] = []
    @Published var allItems: [Item] = []
    @Published private var snippet: Snippet?
    
    // FolderMovable 프로토콜 요구사항 구현
    var allItemsPublisher: AnyPublisher<[Folder], Never> {
        $allItems.eraseToAnyPublisher()
    }
    
    var selectedItemPublisher: AnyPublisher<Snippet?, Never> {
        $snippet.eraseToAnyPublisher()
    }
    
    var cancellables: Set<AnyCancellable> = []  // private 제거
    
    private var snippetSubject: CurrentValueSubject<SnippetMessage?, Never>
    private var snippetUseCase: SnippetUseCase
    
    init(snippetSubject: CurrentValueSubject<SnippetMessage?, Never>, snippetUseCase: SnippetUseCase) {
        self.snippetSubject = snippetSubject
        self.snippetUseCase = snippetUseCase
        setUpHoveringSnippetBindings()
        setupFolderFiltering()
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
                case .snippetSelected(let snippet):
                    self?.snippet = snippet
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
}
