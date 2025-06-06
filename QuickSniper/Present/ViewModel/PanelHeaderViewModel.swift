//
//  PanelHeaderViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 6/6/25.
//

import Foundation
import Combine

final class PanelHeaderViewModel: ObservableObject {
    private let controllerSubject: PassthroughSubject<ControllerMessage, Never>
    
    init(controllerSubject: PassthroughSubject<ControllerMessage, Never>) {
        self.controllerSubject = controllerSubject
    }
    
    func openCreateFolderView() {
        controllerSubject.send(.openCreateFolderView)
    }
    
    func closePanel() {
        controllerSubject.send(.closePanel)
    }
}
