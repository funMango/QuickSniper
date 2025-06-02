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
    private let snippetSubject: PassthroughSubject<Snippet?, Never>
    private var cancellables = Set<AnyCancellable>()
        
    init(
        snippet: Snippet,
        controllSubject: PassthroughSubject<ControllerMessage, Never>,
        snippetSubject: PassthroughSubject<Snippet?, Never>
    ) {
        self.snippet = snippet
        self.controllSubject = controllSubject
        self.snippetSubject = snippetSubject
    }
    
    func openSnippetEditor() {
        print("SnippetCardViewModel애서 openSnippetEditorWith(snippet) 송신")
        controllSubject.send(.openSnippetEditorWith(snippet))
    }
}
