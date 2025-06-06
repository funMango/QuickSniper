//
//  SettingsWindowController.swift
//  QuickSniper
//
//  Created by 이민호 on 5/20/25.
//

import AppKit
import SwiftUI
import Combine
import Resolver

class ShortcutSettingsController: ViewWindowControllable {
    @Injected var viewModelContainer: ViewModelContainer
    var subject: PassthroughSubject<ControllerMessage, Never>
    var hideMessage: ControllerMessage = .hideShorcutSettingView
    var windowController: BaseWindowController<ShortcutSettingsView>?
    var cancellables = Set<AnyCancellable>()
    var width: CGFloat = 300, height: CGFloat = 100
    
    init(subject: PassthroughSubject<ControllerMessage, Never>) {
        self.subject = subject
        controllMessageBindings()
    }
    
    func makeView() -> ShortcutSettingsView {
        return ShortcutSettingsView(
            width: width, height: height
        )
    }
    
    func show() {
        makeWindowController(size: CGSize(width: width, height: height))
    }
    
    func controllMessageBindings() {
        subject
            .sink { [weak self] message in
                guard let self else { return }
                
                switch message {
                case .showShortcutSettingView:                    
                    show()
                default: break
                }
            }
            .store(in: &cancellables)
    }
}
