//
//  BaseWindowController.swift
//  QuickSniper
//
//  Created by 이민호 on 5/26/25.
//

import SwiftUI
import AppKit
import Combine

// MARK: - 입력 가능하고 타이틀바 제거된 Panel
class InputPanel: NSPanel {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }
}

// MARK: - 기본 윈도우 컨트롤러
class BaseWindowController<Content: View>: NSObject, NSWindowDelegate {
    var window: NSWindow?
    private let content: () -> Content
    private let size: CGSize
    private var page: Page
    private let subject: PassthroughSubject<ControllerMessage, Never>
    private var cancellables = Set<AnyCancellable>()
    private var isManualClose: Bool = false

    init(
        size: CGSize,
        page: Page,
        subject: PassthroughSubject<ControllerMessage, Never>,
        @ViewBuilder content: @escaping () -> Content,
    ) {
        self.size = size
        self.page = page
        self.subject = subject
        self.content = content
    }

    func show() {
        subject.send(.pauseAutoHidePanel)
        self.isManualClose = false
        
        if window == nil {
            let hostingView = NSHostingView(rootView: content())

            let panel = InputPanel(
                contentRect: NSRect(x: 0, y: 0, width: size.width, height: size.height),
                styleMask: [.borderless],
                backing: .buffered,
                defer: false
            )

            panel.contentView = hostingView
            panel.backgroundColor = .clear
            panel.isOpaque = false
            panel.hasShadow = true
            panel.isReleasedWhenClosed = false
            panel.hidesOnDeactivate = false
            panel.isMovableByWindowBackground = true
            panel.level = .floating
            panel.delegate = self
            panel.center()
                                                                
            self.window = panel
        }
                
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func windowDidResignKey(_ notification: Notification) {
        if !isManualClose{
            subject.send(.AutoHidePage(page))
            close()
        }
    }
    
    func close(isManualClose: Bool = false) {
        self.isManualClose = isManualClose
        window?.close()
        window = nil
    }

    func windowWillClose(_ notification: Notification) {
        window = nil
    }
}
