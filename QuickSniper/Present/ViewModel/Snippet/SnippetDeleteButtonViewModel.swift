//
//  SnippetDeleteButtonViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 6/3/25.
//

import Foundation
import Combine

final class SnippetDeleteButtonViewModel: ObservableObject {
    private let snippetUseCase: SnippetUseCase
    private let snippetSubject: CurrentValueSubject<SnippetMessage?, Never>
    private var snippet: Snippet? = nil
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        snippetUseCase: SnippetUseCase,
        snippetSubject: CurrentValueSubject<SnippetMessage?, Never>
    ) {
        self.snippetUseCase = snippetUseCase
        self.snippetSubject = snippetSubject
        setUpHoveringSnippet()
    }
    
    func deleteSnippet() {
        guard let snippet = self.snippet else {
            fatalError(
                "[ERROR]: SnippetDeleteButtonViewModel-deleteSnippet, selected snippet is nil"
            )
        }
        
        do {
            try snippetUseCase.deleteSnippet(snippet)
        } catch {
            print("[ERROR]: SnippetDeleteButtonViewModel-deleteSnippet error: \(error)")
        }        
    }
    
    private func setUpHoveringSnippet() {
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
