//
//  KeyboardShortcutManager.swift
//  Shifty
//

import Foundation
import KeyboardShortcuts
import Combine
import AppKit

// MARK: - 단축키 설정 구조체
struct ShortcutConfig {
    let name: KeyboardShortcuts.Name
    let defaultKey: KeyboardShortcuts.Key
    let defaultModifiers: NSEvent.ModifierFlags
    let message: ControllerMessage
    
    init(
        name: KeyboardShortcuts.Name,
        defaultKey: KeyboardShortcuts.Key,
        defaultModifiers: NSEvent.ModifierFlags = [],
        message: ControllerMessage
    ) {
        self.name = name
        self.defaultKey = defaultKey
        self.defaultModifiers = defaultModifiers
        self.message = message
    }
}

final class KeyboardShortcutManager {
    private let controllerSubject: PassthroughSubject<ControllerMessage, Never>
    
    // MARK: - 현재는 toggleQuickSniper만 관리
    private lazy var shortcutConfigs: [ShortcutConfig] = [
        ShortcutConfig(
            name: .toggleQuickSniper,
            defaultKey: .upArrow,
            defaultModifiers: [.command],
            message: .openPanel
        ),
        ShortcutConfig(
            name: .escapedPressed,
            defaultKey: .escape,
            defaultModifiers: [],
            message: .escapePressed
        ),
//        ShortcutConfig(
//            name: .copySnippet,
//            defaultKey: .c,
//            defaultModifiers: [.command],
//            message: .copySnippet
//        )
    ]
    
    init(controllerSubject: PassthroughSubject<ControllerMessage, Never>) {
        self.controllerSubject = controllerSubject
        configureAllShortcuts()
        setupAllHandlers()
    }
    
    // MARK: - 모든 단축키 기본값 설정
    private func configureAllShortcuts() {
        shortcutConfigs.forEach { config in
            if KeyboardShortcuts.getShortcut(for: config.name) == nil {
                let shortcut = KeyboardShortcuts.Shortcut(
                    config.defaultKey,
                    modifiers: config.defaultModifiers
                )
                KeyboardShortcuts.setShortcut(shortcut, for: config.name)
            }
        }
    }
    
    // MARK: - 모든 단축키 핸들러 설정
    private func setupAllHandlers() {
        shortcutConfigs.forEach { config in
            KeyboardShortcuts.onKeyUp(for: config.name) { [weak self] in
                self?.controllerSubject.send(config.message)
            }
        }
    }
}

extension KeyboardShortcuts.Name {
    static let toggleQuickSniper = Self("toggleQuickSniper")
    static let escapedPressed = Self("escapedPressed")
    static let copySnippet = Self("copySnippet")
}
