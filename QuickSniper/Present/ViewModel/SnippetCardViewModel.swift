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
}
