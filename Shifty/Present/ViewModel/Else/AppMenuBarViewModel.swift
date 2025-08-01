//
//  AppMenuBarViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 6/6/25.
//

import Foundation
import Combine

final class AppMenuBarViewModel: ObservableObject {
    private let controllerSubject: PassthroughSubject<ControllerMessage, Never>
    private var cancellables: Set<AnyCancellable> = []
        
    init(
        controllerSubject: PassthroughSubject<ControllerMessage, Never>
    ) {
        self.controllerSubject = controllerSubject
    }
    
    func openPanel() {
        controllerSubject.send(.togglePanel)
    }
    
    func openShortcutSettingsView() {
        controllerSubject.send(.openShortcutSettingView)
    }
}
