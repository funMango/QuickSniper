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
    private let subject: PassthroughSubject<ControllerMessage, Never>
    private var cancellables = Set<AnyCancellable>()
    private var origin: CGPoint? = nil

    init(
        size: CGSize,
        subject: PassthroughSubject<ControllerMessage, Never>,
        origin: CGPoint? = nil,
        @ViewBuilder content: @escaping () -> Content,
    ) {
        self.size = size
        self.origin = origin
        self.content = content
        self.subject = subject
    }

    func show() {
        subject.send(.pauseAutoHidePanel)               
        
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
            panel.center()
                                                                
            self.window = panel
        }
                
        self.window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    private func getCalculatedOrigin(origin: CGPoint) -> NSPoint {
        let realY = origin.y + size.height + 32.0 / 2
        let realX = origin.x + 55.5 / 2
        return NSPoint(x: realX, y: realY)
    }
    
    func close() {
        window?.close()
        window = nil
    }

    func windowWillClose(_ notification: Notification) {
        window = nil
    }
}
