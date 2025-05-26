//
//  ControllerContainer.swift
//  QuickSniper
//
//  Created by 이민호 on 5/22/25.
//

import Foundation
import Combine

enum ControllerMessage {
    case togglePanel
}

final class ControllerContainer {
    private let subject = PassthroughSubject<ControllerMessage, Never>()
    lazy var panelController = PanelController(subject: subject)
    lazy var noteEditorController = NoteEditorController(subject: subject)
    lazy var createFolderController = CreateFolderController(subject: subject)
}
