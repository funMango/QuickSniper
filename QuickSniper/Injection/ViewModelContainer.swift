//
//  ViewModelContainer.swift
//  QuickSniper
//
//  Created by 이민호 on 5/23/25.
//

import Foundation
import SwiftData

final class ViewModelContainer {
    private let modelContext: ModelContext
    lazy var noteEditorViewModel = NoteEditorViewModel()
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
}
