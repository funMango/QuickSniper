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
    
    // MARK: - Properties
    private var allowAutoHide: Bool = true
    private var isPanelVisible = false
    private var subject: PassthroughSubject<ControllerMessage, Never>
    private var cancellables = Set<AnyCancellable>()
    private var isManualHide: Bool = false

    // MARK: - Initialization
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
        fatalError("PanelController does not support Storyboard/XIB initialization. Use init(subject:) instead.")
    }

    // MARK: - Public Methods
    func toggle() {
        isPanelVisible ? performHidePanel() : showPanel()
    }
    
    func hidePanel() {
        isManualHide = true
        performHidePanel()
    }
    
    func AutoHidePanel() {
        performHidePanel()
    }

    // MARK: - Private Methods
    private func showPanel() {
        guard let window = self.window, !isPanelVisible else { return }
        
        isManualHide = false
        let bottomMargin: CGFloat = 10

        let targetFrame = NSRect(
            x: window.frame.origin.x,
            y: bottomMargin,
            width: window.frame.width,
            height: window.frame.height
        )

        let startFrame = NSRect(
            x: targetFrame.origin.x,
            y: -window.frame.height,
            width: targetFrame.width,
            height: targetFrame.height
        )

        window.setFrame(startFrame, display: false)
        window.orderFront(nil)
        window.makeKey()
        
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.25
            context.timingFunction = .init(name: .easeOut)
            window.animator().setFrame(targetFrame, display: true)
        }
        
        isManualHide = false
        isPanelVisible = true
        allowAutoHide = true
        subject.send(.panelStatus(true))
    }
        
    private func performHidePanel() {
        guard let window = self.window, isPanelVisible else { return }
        
        let screen = NSScreen.main?.frame ?? NSRect(x: 0, y: 0, width: 1920, height: 1080)

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
        subject.send(.panelStatus(false))
    }

    // MARK: - Window Delegate
    private func forceFocus() {
        guard let window = self.window else { return }
        
        window.orderFrontRegardless()
        window.makeKey()
        window.makeMain()
        
        // 확실히 하기 위해 한번 더
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            window.makeKey()
        }
    }
    
    func windowDidResignKey(_ notification: Notification) {
        if allowAutoHide && !isManualHide {
            AutoHidePanel()
            subject.send(.AutoHidePage(.panel))
        }
    }

    // MARK: - Setup Methods
    private func configurePanel(_ panel: ShiftyPanel) {
        panel.level = .popUpMenu
        panel.collectionBehavior = [.moveToActiveSpace, .fullScreenAuxiliary]
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
                case .showPanel:
                    self?.showPanel()
                case .hidePanel:
                    self?.hidePanel()
                case .deactivateAutoHidePanel:
                    self?.allowAutoHide = false
                case .activateAutoHidePanel:
                    self?.allowAutoHide = true
                case .focusPanel:
                    self?.forceFocus()
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Factory Methods
    private static func makeHostingView() -> NSHostingView<some View> {
        let modelContext = Resolver.resolve(ModelContext.self)
        let view = PanelView().environment(\.modelContext, modelContext)
        return NSHostingView(rootView: view)
    }

    private static func makeInitialFrame(height: CGFloat) -> NSRect {
        let screen = NSScreen.main?.frame ?? NSRect(x: 0, y: 0, width: 1920, height: 1080)
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
        let panel = ShiftyPanel(
            contentRect: frame,
            styleMask: [.nonactivatingPanel, .borderless],
            backing: .buffered,
            defer: false
        )

        panel.contentView = hosting
        return panel
    }
}




// MARK: - ShiftyPanel
class ShiftyPanel: NSPanel {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }

    override func keyDown(with event: NSEvent) {
        super.keyDown(with: event)
    }
}
