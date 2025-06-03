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
    
    init(
        controllSubject: PassthroughSubject<ControllerMessage, Never>,
    ) {
        self.controllSubject = controllSubject
    }
    
    func openSnippetEditor() {
        controllSubject.send(.openSnippetEditor)
    }
}
