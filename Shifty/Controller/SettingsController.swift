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

class SettingsController: NSObject {
    @Injected var viewModelContainer: ViewModelContainer
    var subject: PassthroughSubject<ControllerMessage, Never>
    var cancellables = Set<AnyCancellable>()
    var shared: NSWindowController?
    let width: CGFloat = 350
    let height: CGFloat = 200
    
    init(subject: PassthroughSubject<ControllerMessage, Never>) {
        self.subject = subject  // super.init() 전에 프로퍼티 초기화
        super.init()            // 그 다음 super.init() 호출
        controllMessageBindings()
    }
    
    func show() {
        if let existing = shared {
            // 기존 창이 있으면 regular app으로 변경하고 앞으로 가져오기
            NSApp.setActivationPolicy(.regular)
            existing.window?.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }

        // regular app으로 변경 - 독에 아이콘 나타나고 다른 앱처럼 동작
        NSApp.setActivationPolicy(.regular)

        let contentView = SettingsView(width: width, height: height)
        let hostingController = NSHostingController(rootView: contentView)
      
        let windowSize = NSSize(width: Int(width), height: Int(height))
        let window = NSWindow(
            contentRect: NSRect(origin: .zero, size: windowSize),
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        
        // 윈도우 설정
        window.title = "Settings"
        window.level = .normal
        window.isMovableByWindowBackground = true
        window.center()
        
        // Visual Effect View 유지 - 기존 배경 그대로
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
                        
        window.isReleasedWhenClosed = true
        let windowController = NSWindowController(window: window)
        
        // 윈도우 델리게이트 설정
        window.delegate = self
        
        windowController.showWindow(nil)
        shared = windowController
        
        // 앱 활성화 및 창을 앞으로
        NSApp.activate(ignoringOtherApps: true)
        window.makeKeyAndOrderFront(nil)
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

// MARK: - NSWindowDelegate
extension SettingsController: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        shared = nil
        
        // 설정 창이 닫히면 다시 백그라운드 앱으로 복원
        NSApp.setActivationPolicy(.accessory)
    }
    
    func windowDidBecomeKey(_ notification: Notification) {
        // 창이 활성화될 때 추가 작업 (필요시)
    }
    
    func windowDidResignKey(_ notification: Notification) {
        // 창이 비활성화될 때 (선택사항)
        // 만약 창이 포커스를 잃으면 즉시 백그라운드로 돌아가고 싶다면:
        // NSApp.setActivationPolicy(.accessory)
    }
}
