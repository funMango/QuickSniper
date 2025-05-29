//
//  ControllerContainer.swift
//  QuickSniper
//
//  Created by 이민호 on 5/22/25.
//

import Foundation
import Combine

final class ControllerContainer {
    private let controllSubject: PassthroughSubject<ControllerMessage, Never>
    private let geometrySubject: CurrentValueSubject<CGRect, Never>
    // var editFolderController: EditFolderController?
    
    init(
        controllSubject: PassthroughSubject<ControllerMessage, Never>,
        geometrySubject: CurrentValueSubject<CGRect, Never>
    ) {
        self.controllSubject = controllSubject
        self.geometrySubject = geometrySubject        
    }
    
    lazy var panelController = PanelController(subject: controllSubject)
    lazy var noteEditorController = NoteEditorController(subject: controllSubject)
    lazy var createFolderController = CreateFolderController(subject: controllSubject)
}
