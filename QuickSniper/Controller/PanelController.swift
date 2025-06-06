//
//  SidePanelController.swift
//  QuickSniper
//
//  Created by 이민호 on 5/19/25.
//

import SwiftUI
import AppKit
import Combine
import Resolver
import SwiftData

class PanelController: NSWindowController, NSWindowDelegate {
    private var allowAutoHide: Bool = true
    private var isPanelVisible = false
    private var previousApp: NSRunningApplication?
    private var subject: PassthroughSubject<ControllerMessage, Never>
    private var cancellables = Set<AnyCancellable>()

    init(subject: PassthroughSubject<ControllerMessage, Never>) {
        self.subject = subject
        
        let hosting = PanelController.makeHostingView()
        let contentHeight = hosting.fittingSize.height
        let initialFrame = PanelController.makeInitialFrame(height: contentHeight)

        let panel = PanelController.makePanel(with: hosting, frame: initialFrame)
        super.init(window: panel)

        panel.delegate = self
        configurePanel(panel)
        setupBindings()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func toggle() {
        isPanelVisible ? hidePanel() : showPanel()
    }

    private func showPanel() {
        guard let window = self.window, !isPanelVisible else { return }
        previousApp = NSWorkspace.shared.frontmostApplication
        let bottomMargin: CGFloat = 10

        let targetFrame = NSRect(
            x: window.frame.origin.x,
            y: bottomMargin, // 하단에서 살짝 띄움
            width: window.frame.width,
            height: window.frame.height
        )

        let startFrame = NSRect(
            x: targetFrame.origin.x,
            y: -window.frame.height, // 아래에서 올라오도록
            width: targetFrame.width,
            height: targetFrame.height
        )

        window.setFrame(startFrame, display: false)
        window.makeKeyAndOrderFront(nil)
        
        if #available(macOS 14.0, *) {
            NSApp.activate() // 단순 activate
        } else {
            NSApp.activate(ignoringOtherApps: true)
        }

        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.25
            context.timingFunction = .init(name: .easeOut)
            window.animator().setFrame(targetFrame, display: true)
        }

        isPanelVisible = true
        allowAutoHide = true
    }

    func hidePanel() {
        guard let window = self.window, isPanelVisible else { return }
        let screen = NSScreen.main!.frame

        let hideFrame = NSRect(
            x: (screen.width - window.frame.width) / 2,
            y: -window.frame.height,
            width: window.frame.width,
            height: window.frame.height
        )

        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.25
            context.timingFunction = .init(name: .easeIn)
            window.animator().setFrame(hideFrame, display: true)
        }, completionHandler: { [weak self] in
            window.orderOut(nil)
            self?.restorePreviousAppFocus()
        })

        isPanelVisible = false
    }
    
    private func restorePreviousAppFocus() {
        guard let previousApp = previousApp,
              !previousApp.isTerminated,
              previousApp != NSRunningApplication.current else { return }
        
        if #available(macOS 14.0, *) {
            // macOS 14+에서는 단순히 activate
            previousApp.activate()
        } else {
            // 이전 버전 호환성
            previousApp.activate(options: .activateIgnoringOtherApps)
        }
        
        // 실패시 대안 - 잠시 후 재시도
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if NSWorkspace.shared.frontmostApplication == NSRunningApplication.current {
                if #available(macOS 14.0, *) {
                    previousApp.activate()
                } else {
                    previousApp.activate(options: .activateAllWindows)
                }
            }
        }
    }

    func windowDidResignKey(_ notification: Notification) {
        if allowAutoHide {
            hidePanel()
        }
    }

    // MARK: - 구성 요소 메서드

    private static func makeHostingView() -> NSHostingView<some View> {
        let modelContext = Resolver.resolve(ModelContext.self)
        let view = PanelView().environment(\.modelContext, modelContext)
        return NSHostingView(rootView: view)
    }

    private static func makeInitialFrame(height: CGFloat) -> NSRect {
        let screen = NSScreen.main!.frame
        let horizontalMargin: CGFloat = 30
        let bottomMargin: CGFloat = 10

        let width = screen.width - (horizontalMargin * 2)
        let x = horizontalMargin
        let y = bottomMargin

        return NSRect(
            x: x,
            y: y,
            width: width,
            height: height
        )
    }

    private static func makePanel(
        with hosting: NSHostingView<some View>,
        frame: NSRect
    ) -> ShiftyPanel {
        let panel: ShiftyPanel = ShiftyPanel(
            contentRect: frame,
            styleMask: [.nonactivatingPanel, .borderless],
            backing: .buffered,
            defer: false
        )

        panel.contentView = hosting
        return panel
    }

    private func configurePanel(_ panel: ShiftyPanel) {
        panel.styleMask.insert(.nonactivatingPanel)
        panel.level = .floating
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        panel.backgroundColor = .clear
        panel.isOpaque = false
        panel.hasShadow = true
        panel.isReleasedWhenClosed = false
        panel.hidesOnDeactivate = false
    }
    
    private func setupBindings() {
        subject
            .sink { [weak self] message in
                switch message {
                case .togglePanel:
                    self?.toggle()
                case .closePanel:
                    self?.hidePanel()
                case .escapePressed:
                    if let window = self?.window, window.isKeyWindow {
                        self?.hidePanel()
                    }
                case .openPanel:
                    self?.isPanelVisible = true
                case .pauseAutoHidePanel:
                    self?.allowAutoHide = false
                case .focusPanel:
                    self?.window?.makeKeyAndOrderFront(nil)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self?.allowAutoHide = true
                    }
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
}

class ShiftyPanel: NSPanel {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }

    override func keyDown(with event: NSEvent) {
        super.keyDown(with: event)
    }
}
