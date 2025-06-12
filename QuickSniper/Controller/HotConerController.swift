//
//  HotConerController.swift
//  QuickSniper
//
//  Created by 이민호 on 6/11/25.
//

import Foundation
import Cocoa
import Combine

class HotCornerController {
    // MARK: Properties
    private var window: NSWindow?
    private var isWidgetVisible = false
    private var trackingView: HotCornerTrackingView?
    private var widgetView: HotCornerWidgetView?
    private var positionCheckTimer: Timer?
    
    private let controllSubject: PassthroughSubject<ControllerMessage, Never>
    private var currentPosition: HotCornerPosition = .bottomLeft
    
    // MARK: Initialization
    init(controllSubject: PassthroughSubject<ControllerMessage, Never>, position: HotCornerPosition = .bottomLeft) {
        self.controllSubject = controllSubject
        self.currentPosition = position
    }
    
    // MARK: Public Methods
    func show() {
        setupDetectionArea()
        startPositionMonitoring()
    }
    
    func updatePosition(_ newPosition: HotCornerPosition) {
        let wasVisible = isWidgetVisible
        
        if wasVisible {
            hideWidget()
        }
        
        currentPosition = newPosition
        setupDetectionArea()
        
        if wasVisible {
            showWidget()
        }
    }
    
    func getCurrentPosition() -> HotCornerPosition {
        return currentPosition
    }
    
    // MARK: Private Methods
    private func setupDetectionArea() {
        guard let screen = NSScreen.main else { return }
        
        let detectionRect = currentPosition.detectionRect(for: screen)
        
        window?.close()
        window = nil
        
        window = NSWindow(
            contentRect: detectionRect,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        
        window?.backgroundColor = .clear
        window?.level = .normal
        window?.isOpaque = false
        window?.collectionBehavior = [.canJoinAllSpaces, .stationary]
        
        setupTrackingView(for: detectionRect)
        window?.orderFront(nil)
    }
    
    private func setupTrackingView(for rect: NSRect) {
        trackingView = HotCornerTrackingView(frame: rect)
        trackingView?.delegate = self  // 🎯 Delegate 설정!
        
        let trackingArea = NSTrackingArea(
            rect: trackingView?.bounds ?? .zero,
            options: [.mouseEnteredAndExited, .activeAlways],
            owner: trackingView,
            userInfo: nil
        )
        trackingView?.addTrackingArea(trackingArea)
        window?.contentView = trackingView
    }
    
    private func showWidget() {
        guard !isWidgetVisible else { return }
        animateWidgetIn()
    }
    
    private func hideWidget() {
        guard isWidgetVisible else { return }
        animateWidgetOut()
    }
    
    private func animateWidgetIn() {
        guard let screen = NSScreen.main else { return }
        
        let startRect = currentPosition.widgetStartRect(for: screen)
        let endRect = currentPosition.widgetEndRect(for: screen)
        
        window?.setFrame(startRect, display: false)
        window?.level = .floating
        
        setupWidgetView(for: endRect)
        
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.3
            context.timingFunction = CAMediaTimingFunction(name: .easeOut)
            window?.animator().setFrame(endRect, display: true)
        }
        
        updateTrackingArea(for: endRect)
        isWidgetVisible = true
    }
    
    private func animateWidgetOut() {
        guard let screen = NSScreen.main else { return }
        
        let hideRect = currentPosition.widgetStartRect(for: screen)
        
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.2
            context.timingFunction = CAMediaTimingFunction(name: .easeIn)
            window?.animator().setFrame(hideRect, display: true)
        } completionHandler: {
            self.resetToDetectionArea()
        }
        
        isWidgetVisible = false
    }
    
    private func setupWidgetView(for rect: NSRect) {
        window?.contentView?.subviews.removeAll()
        
        widgetView = HotCornerWidgetView(frame: window?.contentView?.bounds ?? .zero)
        widgetView?.delegate = self  // 🎯 Delegate 설정!
        widgetView?.configure(for: currentPosition, containerFrame: rect)
        
        if let widgetView = widgetView {
            window?.contentView?.addSubview(widgetView)
        }
    }
    
    private func resetToDetectionArea() {
        guard let screen = NSScreen.main else { return }
        
        let detectionRect = currentPosition.detectionRect(for: screen)
        
        window?.setFrame(detectionRect, display: true)
        window?.backgroundColor = .clear
        window?.level = .floating
        window?.contentView?.subviews.removeAll()
        
        updateTrackingArea(for: detectionRect)
    }
    
    private func startPositionMonitoring() {
        positionCheckTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.checkAndRepositionIfNeeded()
        }
    }
    
    private func checkAndRepositionIfNeeded() {
        guard !isWidgetVisible,
              let screen = NSScreen.main,
              let currentFrame = window?.frame else { return }
        
        let expectedRect = currentPosition.detectionRect(for: screen)
        
        if abs(currentFrame.minY - expectedRect.minY) > 5 ||
           abs(currentFrame.minX - expectedRect.minX) > 5 {
            window?.setFrame(expectedRect, display: true)
            updateTrackingArea(for: expectedRect)
        }
    }
    
    private func updateTrackingArea(for rect: NSRect) {
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

// MARK: - 5. HotCornerController + Delegate 구현
extension HotCornerController: HotCornerViewDelegate {
    
    func hotCornerViewDidClick() {
        // 🎯 클릭 이벤트를 ControllerMessage로 전달
        controllSubject.send(.togglePanel)
    }
    
    func hotCornerViewMouseEntered() {
        // 🎯 마우스 진입 - 위젯 표시
        showWidget()
    }
    
    func hotCornerViewMouseExited() {
        // 🎯 마우스 나감 - 위젯 숨김
        hideWidget()
    }
}
