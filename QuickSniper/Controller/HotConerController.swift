//
//  HotConerController.swift
//  QuickSniper
//
//  Created by 이민호 on 6/11/25.
//

import Foundation
import Cocoa
import Combine

// MARK: - Custom View for Mouse Tracking
class HotCornerView: NSView {
    weak var controller: HotCornerController?
    
    override func mouseEntered(with event: NSEvent) {
        controller?.showWidget()
    }
    
    override func mouseExited(with event: NSEvent) {
        controller?.hideWidget()
    }
    
    override func mouseDown(with event: NSEvent) {
        controller?.widgetClicked()
    }
}

// MARK: - Hot Corner Controller
class HotCornerController {
    // MARK: Properties
    private var window: NSWindow?
    private var isWidgetVisible = false
    private let controllSubject: PassthroughSubject<ControllerMessage, Never>
    private var cancellables = Set<AnyCancellable>()
    private var positionCheckTimer: Timer?
    
    // MARK: Initialization
    init(controllSubject: PassthroughSubject<ControllerMessage, Never>) {
        self.controllSubject = controllSubject
        setupBindings()
    }
    
    // MARK: Public Methods
    func show() {
        setupDetectionArea()
        startPositionMonitoring()
    }
    
    func showWidget() {
        guard !isWidgetVisible else { return }
        animateWidgetIn()
    }
    
    func hideWidget() {
        guard isWidgetVisible else { return }
        animateWidgetOut()
    }
    
    func widgetClicked() {
        controllSubject.send(.togglePanel)
    }
}

// MARK: - Setup Methods
private extension HotCornerController {
    func setupBindings() {
        controllSubject
            .sink { [weak self] message in
                if case .showHotCorner = message {
                    self?.show()
                }
            }
            .store(in: &cancellables)
    }
    
    func setupDetectionArea() {
        guard let screen = NSScreen.main else { return }
        
        let fullFrame = screen.frame
        
        let detectionRect = NSRect(
            x: fullFrame.minX,
            y: fullFrame.minY,
            width: 20,
            height: 40
        )
        
        window = NSWindow(
            contentRect: detectionRect,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        
        window?.backgroundColor = .clear
        window?.level = .floating
        window?.isOpaque = false
        window?.collectionBehavior = [.canJoinAllSpaces, .stationary]
        
        setupHotCornerView(for: detectionRect)
        window?.orderFront(nil)
    }
    
    func setupHotCornerView(for rect: NSRect) {
        let hotCornerView = HotCornerView(frame: rect)
        hotCornerView.controller = self
        
        let trackingArea = NSTrackingArea(
            rect: hotCornerView.bounds,
            options: [.mouseEnteredAndExited, .activeAlways],
            owner: hotCornerView,
            userInfo: nil
        )
        hotCornerView.addTrackingArea(trackingArea)
        
        window?.contentView = hotCornerView
    }
    
    func setupWidgetView() {
        guard let contentView = window?.contentView else { return }
        
        contentView.subviews.removeAll()
        
        let backgroundView = createBackgroundView(frame: contentView.bounds)
        let iconImageView = createIconView()
        
        backgroundView.addSubview(iconImageView)
        contentView.addSubview(backgroundView)
    }
    
    func createBackgroundView(frame: NSRect) -> NSView {
        let view = NSView(frame: frame)
        view.wantsLayer = true
        view.layer?.cornerRadius = 12
        
        // 다크모드에 따른 배경색 설정
        let isDarkMode = NSApp.effectiveAppearance.name == .darkAqua
        let backgroundColor = isDarkMode ? NSColor.gray : NSColor.white
        view.layer?.backgroundColor = backgroundColor.withAlphaComponent(0.8).cgColor
        
        return view
    }
    
    func createIconView() -> NSImageView {
        let iconView = NSImageView(frame: NSRect(x: 35, y: 25, width: 20, height: 20))
        iconView.image = NSImage(systemSymbolName: "arrow.up.right.circle", accessibilityDescription: nil)
        
        // 다크모드에 따른 아이콘 색상 설정
        let isDarkMode = NSApp.effectiveAppearance.name == .darkAqua
        iconView.contentTintColor = isDarkMode ? .white : .black
        
        return iconView
    }
    
    func startPositionMonitoring() {
        positionCheckTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.checkAndRepositionIfNeeded()
        }
    }
    
    func checkAndRepositionIfNeeded() {
        guard !isWidgetVisible,
              let screen = NSScreen.main else { return }
        
        guard let currentFrame = window?.frame else { return }
        
        let fullFrame = screen.frame
        let expectedRect = NSRect(x: fullFrame.minX, y: fullFrame.minY, width: 20, height: 40)
        
        // 위치가 5픽셀 이상 차이나면 재조정
        if abs(currentFrame.minY - expectedRect.minY) > 5 || abs(currentFrame.minX - expectedRect.minX) > 5 {
            window?.setFrame(expectedRect, display: true)
            updateTrackingArea(for: expectedRect)
        }
    }
}

// MARK: - Animation Methods
private extension HotCornerController {
    func animateWidgetIn() {
        guard let screen = NSScreen.main else { return }
        
        let fullFrame = screen.frame
        
        let startRect = NSRect(x: fullFrame.minX - 40, y: fullFrame.minY - 30, width: 60, height: 50)
        let endRect = NSRect(x: fullFrame.minX - 20, y: fullFrame.minY - 10, width: 60, height: 50)
        
        window?.setFrame(startRect, display: false)
        window?.level = .screenSaver
        
        setupWidgetView()
        
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.3
            context.timingFunction = CAMediaTimingFunction(name: .easeOut)
            window?.animator().setFrame(endRect, display: true)
        }
        
        updateTrackingArea(for: endRect)
        isWidgetVisible = true
    }
    
    func animateWidgetOut() {
        guard let screen = NSScreen.main else { return }
        
        let fullFrame = screen.frame
        let hideRect = NSRect(x: fullFrame.minX - 40, y: fullFrame.minY - 30, width: 60, height: 50)
        
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.2
            context.timingFunction = CAMediaTimingFunction(name: .easeIn)
            window?.animator().setFrame(hideRect, display: true)
        } completionHandler: {
            self.resetToDetectionArea()
        }
        
        isWidgetVisible = false
    }
    
    func resetToDetectionArea() {
        guard let screen = NSScreen.main else { return }
        
        let fullFrame = screen.frame
        let detectionRect = NSRect(x: fullFrame.minX, y: fullFrame.minY, width: 20, height: 40)
        
        window?.setFrame(detectionRect, display: true)
        window?.backgroundColor = .clear
        window?.level = .floating
        window?.contentView?.subviews.removeAll()
        
        updateTrackingArea(for: detectionRect)
    }
}

// MARK: - Utility Methods
private extension HotCornerController {
    func updateTrackingArea(for rect: NSRect) {
        guard let contentView = window?.contentView else { return }
        
        contentView.trackingAreas.forEach { contentView.removeTrackingArea($0) }
        
        let trackingArea = NSTrackingArea(
            rect: NSRect(x: 0, y: 0, width: rect.width, height: rect.height),
            options: [.mouseEnteredAndExited, .activeAlways],
            owner: contentView,
            userInfo: nil
        )
        contentView.addTrackingArea(trackingArea)
    }
}
