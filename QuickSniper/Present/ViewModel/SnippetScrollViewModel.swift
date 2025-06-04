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
    private var snippetSubject: CurrentValueSubject<SnippetMessage?, Never>
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        snippetUseCase: SnippetUseCase,
        selectedFolderSubject: CurrentValueSubject<Folder?, Never>,
        snippetSubject: CurrentValueSubject<SnippetMessage?, Never>
    ) {
        self.snippetUseCase = snippetUseCase
        self.selectedFolderSubject = selectedFolderSubject
        self.snippetSubject = snippetSubject
        setupSelectedFolderBindings()
        switchSnippetOrder()
        saveSnippets()
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
    
    private func switchSnippetOrder() {
        snippetSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                switch message {
                case .switchOrder(let draggingSnippet, let currentSnippet):
                    self?.handleSwitchOrder(
                        draggingSnippet: draggingSnippet,
                        currentSnippet: currentSnippet
                    )
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    private func handleSwitchOrder(draggingSnippet: Snippet, currentSnippet: Snippet) {
        guard draggingSnippet.id != currentSnippet.id else { return }

        guard let dragIdx = snippets.firstIndex(where: { $0.id == draggingSnippet.id }),
              let curIdx  = snippets.firstIndex(where: { $0.id == currentSnippet.id }) else { return }
       
        snippets.swapAt(dragIdx, curIdx)

        // 2) 새 인덱스에 맞춰 order 동기화
        for (i, s) in snippets.enumerated() {
            s.order = i
        }
        
        print("snippet 변경 완료")
        for s in snippets {
            print("title: \(s.title), order: \(s.order)")
        }
        
        do {
            try self.snippetUseCase.updateAllSnippets(snippets)
        } catch {
            print("[ERROR]: SnippetScrollViewModel-handleSwitchOrder \(error)")
        }
    }
    
    private func saveSnippets() {
        snippetSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                guard let self = self else { return }
                
                switch message {
                case .saveSnippets:
                    do {
                        try self.snippetUseCase.updateAllSnippets(snippets)
                    } catch {
                        print("[ERROR]: SnippetScrollViewModel-saveSnippets \(error)")
                    }
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
}
