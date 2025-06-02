//
//  SnippetPlusButtonViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 6/2/25.
//

import Foundation
import Combine

final class SnippetPlusButtonViewModel: ObservableObject {
    private var controllSubject: PassthroughSubject<ControllerMessage, Never>
    private var snippetSubject: PassthroughSubject<Snippet?, Never>
    private var cancellables = Set<AnyCancellable>()
    
    init(
        controllSubject: PassthroughSubject<ControllerMessage, Never>,
        snippetSubject: PassthroughSubject<Snippet?, Never>
    ) {
        self.controllSubject = controllSubject
        self.snippetSubject = snippetSubject
    }
    
    func openSnippetEditor() {
        controllSubject.send(.openSnippetEditor)
    }
}
