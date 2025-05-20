//
//  SidePanelController.swift
//  QuickSniper
//
//  Created by 이민호 on 5/19/25.
//

import SwiftUI
import AppKit
import KeyboardShortcuts

class PanelController: NSWindowController {
    static let shared = PanelController()
    private var isPanelVisible = false

    init() {
        let screen = NSScreen.main!.frame
        let panelWidth: CGFloat = screen.width

        // 먼저 HostingView를 만든다
        let hosting = NSHostingView(rootView: PanelView())

        // fittingSize를 사용하여 SwiftUI 뷰의 실제 높이를 계산
        let contentHeight = hosting.fittingSize.height

        // 초기 프레임 설정 (뷰 높이에 맞게 자동 계산)
        let initialFrame = NSRect(
            x: 0,
            y: 0,
            width: panelWidth,
            height: contentHeight
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

        // 컨텐츠 뷰 설정
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

        // 최종 위치
        let targetFrame = NSRect(
            x: (screen.width - window.frame.width) / 2,
            y: 0,
            width: window.frame.width,
            height: window.frame.height
        )

        // 시작 위치 (아래쪽)
        let startFrame = NSRect(
            x: targetFrame.origin.x,
            y: -window.frame.height,
            width: targetFrame.width,
            height: targetFrame.height
        )

        window.setFrame(startFrame, display: false)
        window.makeKeyAndOrderFront(nil)

        // 애니메이션 적용
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.25
            context.timingFunction = .init(name: .easeOut)
            window.animator().setFrame(targetFrame, display: true)
        }

        isPanelVisible = true
    }

    private func hidePanel() {
        guard let window = self.window, isPanelVisible else { return }
        let screen = NSScreen.main!.frame

        // 최종 사라질 위치 (아래로)
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
}

class SniperPanel: NSPanel {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }
}
