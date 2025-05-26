//
//  NoteEditorViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 5/22/25.
//

import Foundation
import Combine

class NoteEditorViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var content: String = ""
    private var subject: PassthroughSubject<ControllerMessage, Never>
    
    init(
        title: String = "",
        content: String = "",
        subject: PassthroughSubject<ControllerMessage, Never>
    ) {
        self.title = title
        self.content = content
        self.subject = subject
    }
    
    func hide() {
        subject.send(.hideNoteEditorView)
    }
}
