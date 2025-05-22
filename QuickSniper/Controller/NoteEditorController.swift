//
//  ControllerContainer.swift
//  QuickSniper
//
//  Created by 이민호 on 5/22/25.
//

import AppKit
import SwiftUI
import Combine

class NoteEditorController: NSObject, NSWindowDelegate {
    private var window: NSWindow?
    private var subject: PassthroughSubject<ControllerMessage, Never>
    
    init(subject: PassthroughSubject<ControllerMessage, Never>) {
        self.subject = subject
    }
    
    func show() {
        if window == nil {
            let hosting = NSHostingView(rootView: NoteEditorView())
            let win = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 600, height: 700),
                styleMask: [.titled, .closable, .miniaturizable],
                backing: .buffered, defer: false)
            win.center()
            win.contentView = hosting
            win.title = ""
            win.titleVisibility = .hidden
            win.titlebarAppearsTransparent = true
            win.isReleasedWhenClosed = false
            win.level = .floating
            win.delegate = self
            window = win
        }
        window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    func windowWillClose(_ notification: Notification) {        
        subject.send(.togglePanel)
    }
}
