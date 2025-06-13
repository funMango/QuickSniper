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

class SettingsController  {
    @Injected var viewModelContainer: ViewModelContainer
    var subject: PassthroughSubject<ControllerMessage, Never>
    var cancellables = Set<AnyCancellable>()
    var shared: NSWindowController?
    let width: CGFloat = 350
    let height: CGFloat = 200
    
    init(subject: PassthroughSubject<ControllerMessage, Never>) {
        self.subject = subject
        controllMessageBindings()        
    }
    
    func show() {
        if let existing = shared {
            existing.window?.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }

        let contentView = SettingsView(width: width, height: height)
        let hostingController = NSHostingController(rootView: contentView)
      
        let windowSize = NSSize(width: Int(width), height: Int(height))
        let window = NSWindow(
            contentRect: NSRect(origin: .zero, size: windowSize),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        
        let visualEffectView = NSVisualEffectView()
        visualEffectView.material = .menu
        visualEffectView.blendingMode = .behindWindow
        visualEffectView.state = .active
        
        window.contentView = visualEffectView
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        visualEffectView.addSubview(hostingController.view)
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: visualEffectView.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: visualEffectView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: visualEffectView.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: visualEffectView.bottomAnchor)
        ])
                        
        window.isReleasedWhenClosed = false
        let windowController = NSWindowController(window: window)
        windowController.showWindow(nil)
        shared = windowController
        
        // 중앙 정렬
        if let screen = NSScreen.main {
            let screenRect = screen.visibleFrame
            let windowRect = window.frame
            let x = screenRect.midX - windowRect.width / 2
            let y = screenRect.midY - windowRect.height / 2
            window.setFrameOrigin(NSPoint(x: x, y: y))
        }                                        
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
