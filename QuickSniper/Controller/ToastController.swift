//
//  ToastController.swift
//  QuickSniper
//
//  Created by 이민호 on 6/13/25.
//

import AppKit
import SwiftUI
import Combine

final class ToastController: NSPanel {
    private var hostingView: NSHostingView<ToastView>?
    private let controllSubject: PassthroughSubject<ControllerMessage, Never>
    private var cancellables: Set<AnyCancellable> = []
    
    init(controllSubject: PassthroughSubject<ControllerMessage, Never>) {
        self.controllSubject = controllSubject
                
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 80),
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
                
        setupWindow()
        setupControllMessageBindings()
    }
    
    private func setupWindow() {
        // 윈도우 설정
        isOpaque = false
        backgroundColor = .clear
        hasShadow = true
        
        // 다른 앱 위에 표시
        level = .floating
        
        // 클릭 무시 (상호작용 차단)
        ignoresMouseEvents = true
        
        // 독 및 윈도우 스위처에서 숨김
        collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle]
        
        // 포커스 받지 않음
        hidesOnDeactivate = false
    }
    
    // MARK: - Toast Display
    func showToast(_ toast: ToastMessage) {
        resetExistingToast()
        setupHostingView(for: toast)
        scheduleAutoHide(after: toast.duration)
    }
    
    private func resetExistingToast() {
        if hostingView != nil {
            orderOut(nil)
            hostingView = nil
        }
    }
    
    private func setupHostingView(for toast: ToastMessage) {
        let toastView = ToastView(toast: toast)
        hostingView = NSHostingView(rootView: toastView)
        
        guard let hostingView = hostingView else { return }
        
        configureHostingView(hostingView)
        configureLayout()
    }
    
    private func configureHostingView(_ hostingView: NSHostingView<ToastView>) {
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        contentView = hostingView
        
        setupConstraints(for: hostingView)
        setupPriorities(for: hostingView)
        forceLayoutUpdate(hostingView)
    }
    
    private func setupConstraints(for hostingView: NSHostingView<ToastView>) {
        NSLayoutConstraint.activate([
            hostingView.topAnchor.constraint(equalTo: contentView!.topAnchor),
            hostingView.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor),
            hostingView.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor),
            hostingView.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor)
        ])
    }
    
    private func setupPriorities(for hostingView: NSHostingView<ToastView>) {
        hostingView.setContentHuggingPriority(.required, for: .horizontal)
        hostingView.setContentHuggingPriority(.required, for: .vertical)
        hostingView.setContentCompressionResistancePriority(.required, for: .horizontal)
        hostingView.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    private func forceLayoutUpdate(_ hostingView: NSHostingView<ToastView>) {
        hostingView.needsLayout = true
        hostingView.layoutSubtreeIfNeeded()
    }
    
    private func configureLayout() {
        DispatchQueue.main.async { [weak self] in
            self?.adjustSizeAndPosition()
        }
    }
    
    private func adjustSizeAndPosition() {
        guard let hostingView = hostingView else { return }
        
        let fittingSize = hostingView.fittingSize
        let finalSize = NSSize(
            width: max(fittingSize.width, 250),
            height: max(fittingSize.height, 60)
        )
        
        setContentSize(finalSize)
        positionAtTopCenter()
        showWithAnimation()
    }
    
    private func scheduleAutoHide(after duration: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
            self?.hideWithAnimation()
        }
    }
    
    // MARK: - Positioning & Animation
    private func positionAtTopCenter() {
        guard let screen = NSScreen.main else { return }
        
        let screenFrame = screen.visibleFrame
        let windowFrame = frame
        
        let x = screenFrame.midX - windowFrame.width / 2
        let y = screenFrame.maxY - windowFrame.height - 50 // 상단에서 50px 아래
        
        setFrameOrigin(NSPoint(x: x, y: y))
    }
    
    private func showWithAnimation() {
        alphaValue = 0.0
        orderFront(nil)
        
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.5
            context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            animator().alphaValue = 1.0
        }
    }
    
    private func hideWithAnimation() {
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.5
            context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            animator().alphaValue = 0.0
        }) { [weak self] in
            self?.orderOut(nil)
            self?.hostingView = nil
        }
    }
    
    // MARK: - Message Handling
    private func setupControllMessageBindings() {
        controllSubject
            .sink { [weak self] message in
                guard let self else { return }
                
                switch message {
                case .showToast(let title):
                    let toast = ToastMessage.copySuccess(snippetTitle: title)
                    self.showToast(toast)
                default:
                    return
                }
            }
            .store(in: &cancellables)
    }
}
