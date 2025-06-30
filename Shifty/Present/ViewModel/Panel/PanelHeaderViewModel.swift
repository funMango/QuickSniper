//
//  PanelHeaderViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 6/6/25.
//

import Foundation
import Combine
import Resolver

final class PanelHeaderViewModel: ObservableObject {
    private let controllerSubject: PassthroughSubject<ControllerMessage, Never>
    
    init(controllerSubject: PassthroughSubject<ControllerMessage, Never>) {
        self.controllerSubject = controllerSubject
    }
                        
    func closePanel() {
        controllerSubject.send(.hidePanel)
    }
}


