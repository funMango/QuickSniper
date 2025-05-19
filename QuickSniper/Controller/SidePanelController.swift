//
//  SidePanelController.swift
//  QuickSniper
//
//  Created by 이민호 on 5/19/25.
//

import SwiftUI
import AppKit

class SidePanelController: NSWindowController {
    private var monitorTimer: Timer?
    private var isPanelVisible = false

    init() {
        let screen = NSScreen.main!.frame

        let initialFrame = NSRect(
            x: screen.maxX,  // 👉 오른쪽 바깥
            y: screen.minY,
            width: 280,
            height: screen.height
        )

        let panel = SniperPanel(
            contentRect: initialFrame,
            styleMask: NSWindow.StyleMask([.nonactivatingPanel, .borderless]),
            backing: .buffered,
            defer: false
        )

        panel.styleMask.insert(NSWindow.StyleMask.nonactivatingPanel)
        panel.level = NSWindow.Level.statusBar
        panel.collectionBehavior = NSWindow.CollectionBehavior([.canJoinAllSpaces, .fullScreenAuxiliary])
        panel.backgroundColor = NSColor.clear
        panel.isOpaque = false
        panel.hasShadow = true
        panel.isReleasedWhenClosed = false
        panel.hidesOnDeactivate = false

        let hosting = NSHostingView(rootView: SidePanelView())
        panel.contentView = hosting

        super.init(window: panel)
        startMonitoringCursor()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func startMonitoringCursor() {
        monitorTimer = Timer.scheduledTimer(withTimeInterval: 1.0 / 30.0, repeats: true) { _ in
            guard let screen = NSScreen.main else { return }
            let location = NSEvent.mouseLocation
            let windowFrame = self.window?.frame ?? .zero
            let isMouseInsidePanel = windowFrame.contains(location)
            let isAtScreenEdge = location.x >= screen.frame.maxX - 2 // 딱 끝에 닿았을 때만

            if !self.isPanelVisible && isAtScreenEdge {
                self.showPanel()
            } else if self.isPanelVisible && !isMouseInsidePanel && !isAtScreenEdge {
                self.hidePanel()
            }
        }
    }
    
    private func showPanel() {
        guard let window = self.window, !isPanelVisible else { return }

        let screen = NSScreen.main!.frame
        var targetFrame = window.frame
        targetFrame.origin.x = screen.width - targetFrame.width
        targetFrame.origin.y = 0
        targetFrame.size.height = screen.height
        
        window.setIsVisible(true)
        window.animator().setFrame(targetFrame, display: true)
        window.makeKeyAndOrderFront(nil)

        isPanelVisible = true
    }

    private func hidePanel() {
        guard let window = self.window, isPanelVisible else { return }

        let screen = NSScreen.main!.frame
        var hiddenFrame = window.frame
        hiddenFrame.origin.x = screen.width  // 화면 바깥쪽으로 밀기

        // 부드럽게 사라지게 하고 잠시 뒤에 완전히 닫기
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.25
            window.animator().setFrame(hiddenFrame, display: true)
        }) {
            window.orderOut(nil)
        }

        isPanelVisible = false
    }

    private func slideIn() {
        guard let window = self.window else { return }

        let screen = NSScreen.main!.frame
        var targetFrame = window.frame
        targetFrame.origin.x = screen.width - targetFrame.width
        targetFrame.origin.y = 0
        targetFrame.size.height = screen.height

        window.setFrame(targetFrame, display: true, animate: true)
        window.makeKeyAndOrderFront(nil)
    }
}

class SniperPanel: NSPanel {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }
}
