//
//  QuickSniperApp.swift
//  QuickSniper
//
//  Created by 이민호 on 5/19/25.
//

import SwiftUI
import AppKit
import KeyboardShortcuts
import Resolver

@main
struct QuickSniperApp: App {
    @StateObject private var settingsWindowController = SettingsWindowController()
    private let container:  ControllerContainer
    

    init() {
        self.container = Resolver.resolve(ControllerContainer.self)
        
        configureKeyboardShortcuts()
        runInitialLaunchActions()
    }

    var body: some Scene {
        MenuBarExtra("QuickSniper", systemImage: "bolt.circle.fill") {
            Button("패널 토글") {
                container.panelController.toggle()
            }

            Button("단축키 설정") {
                settingsWindowController.showSettings()
            }

            Divider()

            Button("종료", role: .destructive) {
                NSApplication.shared.terminate(nil)
            }
        }
        .menuBarExtraStyle(.window)
    }
    
    private func configureKeyboardShortcuts() {
        if KeyboardShortcuts.getShortcut(for: .toggleQuickSniper) == nil {
            let shortcut = KeyboardShortcuts.Shortcut(.k, modifiers: [.option])
            KeyboardShortcuts.setShortcut(shortcut, for: .toggleQuickSniper)
        }

        KeyboardShortcuts.onKeyUp(for: .toggleQuickSniper) {
            container.panelController.toggle()
        }
    }
    
    private func runInitialLaunchActions() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            container.panelController.toggle()
        }
    }
}
