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
    }
    
    func openSnippetEditor() {        
        controllSubject.send(.openSnippetEditorWith(snippet))
    }
    
    func sendSelectedSnippet() {
        snippetSubject.send(.snippetHovering(snippet))
    }
    
    func sendReorderSnippetId(sorceId: String, targetId: String) {
        snippetSubject.send(.snippetReorder(sorceId, targetId))
    }
    
    func switchSnippetOrder(draggingSnippet: Snippet, edge: Edge) {
        switch edge {
            case .left:
            if draggingSnippet.order > snippet.order {
                snippetSubject.send(.switchOrder(draggingSnippet, snippet))
            }
            case .right:
            if draggingSnippet.order < snippet.order {
                snippetSubject.send(.switchOrder(draggingSnippet, snippet))
            }
        }
    }
    
    func sendSaveSnippets() {
        snippetSubject.send(.saveSnippets)
    }
    
    
}
