//
//  NoteEditorViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 5/22/25.
//

import Foundation
import Resolver

class NoteEditorViewModel: ObservableObject {
    @Injected var container: ControllerContainer
    @Published var title: String = ""
    @Published var content: String = ""
    
    func hide() {
        container.noteEditorController.hide()
    }
    
    
}
