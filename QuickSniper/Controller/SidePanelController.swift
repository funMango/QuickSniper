//
//  SidePanelController.swift
//  QuickSniper
//
//  Created by 이민호 on 5/19/25.
//

import SwiftUI
import AppKit
import KeyboardShortcuts

class SidePanelController: NSWindowController {
    static let shared = SidePanelController()
    private var isPanelVisible = false

    init() {
        let screen = NSScreen.main!.frame
        let panelWidth: CGFloat = screen.width
        let panelHeight: CGFloat = 180

        let initialFrame = NSRect(
            x: 0,
            y: 0,
            width: panelWidth,
            height: panelHeight
        )

        let panel = SniperPanel(
            contentRect: initialFrame,
            styleMask: [.nonactivatingPanel, .borderless],
            backing: .buffered,
            defer: false
        )

        panel.styleMask.insert(.nonactivatingPanel)
        panel.level = .statusBar
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        panel.backgroundColor = .clear
        panel.isOpaque = false
        panel.hasShadow = true
        panel.isReleasedWhenClosed = false
        panel.hidesOnDeactivate = false

        let hosting = NSHostingView(rootView: SidePanelView())
        panel.contentView = hosting

        super.init(window: panel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func toggle() {
        isPanelVisible ? hidePanel() : showPanel()
    }

    private func showPanel() {
        guard let window = self.window, !isPanelVisible else { return }
        let screen = NSScreen.main!.frame

        let targetFrame = NSRect(
            x: (screen.width - window.frame.width) / 2,
            y: 0,
            width: window.frame.width,
            height: window.frame.height
        )

        window.setFrame(targetFrame, display: true)
        window.makeKeyAndOrderFront(nil)
        isPanelVisible = true
    }

    private func hidePanel() {
        guard let window = self.window, isPanelVisible else { return }
        window.orderOut(nil)
        isPanelVisible = false
    }
}

class SniperPanel: NSPanel {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }
}
