//
//  SnippetCardViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 6/1/25.
//

import Foundation
import Combine

final class SnippetCardViewModel: ObservableObject {
    @Published var snippet: Snippet
    @Published var isSelected: Bool = false
    private let controllSubject: PassthroughSubject<ControllerMessage, Never>
    private let snippetSubject: CurrentValueSubject<SnippetMessage?, Never>
    private var cancellables = Set<AnyCancellable>()
        
    init(
        snippet: Snippet,
        controllSubject: PassthroughSubject<ControllerMessage, Never>,
        snippetSubject: CurrentValueSubject<SnippetMessage?, Never>
    ) {
        self.snippet = snippet
        self.controllSubject = controllSubject
        self.snippetSubject = snippetSubject
        selectedSnippetBindings()
    }
    
    func openSnippetEditor() {        
        controllSubject.send(.openSnippetEditorWith(snippet))
    }
    
    func sendSelectedSnippet() {
        snippetSubject.send(.snippetHovering(snippet))
    }
    
    func sendSelectedSnippetMessage() {        
        snippetSubject.send(.snippetSelected(snippet))
    }
    
    func selectedSnippetBindings() {
        snippetSubject.sink { [weak self] message in
            guard let self = self else { return }
            
            switch message {
            case .snippetSelected(let snippet):
                isSelected = snippet.id == self.snippet.id
            default: return
            }
        }
        .store(in: &cancellables)
    }
}
