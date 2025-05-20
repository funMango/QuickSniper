//
//  QuickSniperApp.swift
//  QuickSniper
//
//  Created by 이민호 on 5/19/25.
//

import SwiftUI
import AppKit
import KeyboardShortcuts

@main
struct QuickSniperApp: App {
    @StateObject private var settingsWindowController = SettingsWindowController()

    init() {
        if KeyboardShortcuts.getShortcut(for: .toggleQuickSniper) == nil {
            let shortcut = KeyboardShortcuts.Shortcut(.k, modifiers: [.option])
            KeyboardShortcuts.setShortcut(shortcut, for: .toggleQuickSniper)
        }

        KeyboardShortcuts.onKeyUp(for: .toggleQuickSniper) {            
            PanelController.shared.toggle()
        }
    }

    var body: some Scene {
        MenuBarExtra("QuickSniper", systemImage: "bolt.circle.fill") {
            Button("패널 토글") {
                PanelController.shared.toggle()
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
}
