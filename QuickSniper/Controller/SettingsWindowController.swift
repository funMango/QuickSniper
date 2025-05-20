//
//  SettingsWindowController.swift
//  QuickSniper
//
//  Created by 이민호 on 5/20/25.
//

import AppKit
import SwiftUI

class SettingsWindowController: ObservableObject {
    private var window: NSWindow?

    func showSettings() {
        if window == nil {
            let hosting = NSHostingController(rootView: SettingsView())
            window = NSWindow(
                contentViewController: hosting
            )
            window?.title = "단축키 설정"
            window?.setContentSize(NSSize(width: 300, height: 100))
            window?.styleMask = [.titled, .closable, .miniaturizable]
            window?.isReleasedWhenClosed = false
        }
        window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}
