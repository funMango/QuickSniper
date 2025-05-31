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
        NSApp.activate(ignoringOtherApps: true)

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
        }, completionHandler: {
            window.orderOut(nil)
        })

        isPanelVisible = false
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
    ) -> SniperPanel {
        let panel: SniperPanel = SniperPanel(
            contentRect: frame,
            styleMask: [.nonactivatingPanel, .borderless],
            backing: .buffered,
            defer: false
        )

        panel.contentView = hosting
        return panel
    }

    private func configurePanel(_ panel: SniperPanel) {
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
                case .pauseAutoHidePanel:
                    self?.allowAutoHide = false
                case .focusPanel:
                    self?.window?.makeKeyAndOrderFront(nil)
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
}

class SniperPanel: NSPanel {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }

    override func keyDown(with event: NSEvent) {
        if event.keyCode == 53 { // ESC
            (self.delegate as? PanelController)?.hidePanel()
        } else {
            super.keyDown(with: event)
        }
    }
}
