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
    private var currentPosition: HotCornerPosition = .bottomLeft
    
    // MARK: Initialization
    init(
        controllSubject: PassthroughSubject<ControllerMessage, Never>,
        position: HotCornerPosition = .bottomRight
    ) {
        self.controllSubject = controllSubject
        self.currentPosition = position
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
    
    func updatePosition(_ newPosition: HotCornerPosition) {
        let wasVisible = isWidgetVisible
        
        // 현재 위젯이 표시중이면 숨김
        if wasVisible {
            hideWidget()
        }
        
        // 위치 업데이트
        currentPosition = newPosition
        
        // 감지 영역 재설정
        setupDetectionArea()
        
        // 위젯이 표시중이었다면 다시 표시
        if wasVisible {
            showWidget()
        }
    }
    
    func getCurrentPosition() -> HotCornerPosition {
        return currentPosition
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
        
        // 🔍 디버깅: 화면 정보 출력
        let fullFrame = screen.frame
        let visibleFrame = screen.visibleFrame
        
        print("=== 화면 정보 ===")
        print("전체 화면: \(fullFrame)")
        print("사용 가능 화면: \(visibleFrame)")
        print("현재 위치: \(currentPosition)")
        
        /// 현재 위치에 따른 감지 영역 계산
        let detectionRect = currentPosition.detectionRect(for: screen)
        
        print("감지 영역: \(detectionRect)")
        print("================")
                
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
        
        // 🔍 디버깅: 윈도우가 생성되었는지 확인
        if let window = window {
            print("윈도우 생성 성공: \(window.frame)")
        } else {
            print("❌ 윈도우 생성 실패")
        }
        
        setupHotCornerView(for: detectionRect)
        window?.orderFront(nil)
        
        // 🔍 디버깅: 윈도우가 표시되었는지 확인
        print("윈도우 표시 완료")
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
        let iconImageView = createPositionBasedIconView(for: contentView.bounds)
        
        backgroundView.addSubview(iconImageView)
        contentView.addSubview(backgroundView)
    }
    
    func createBackgroundView(frame: NSRect) -> NSView {
        let view = NSView(frame: frame)
        view.wantsLayer = true
        view.layer?.cornerRadius = 12
                
        let isDarkMode = NSApp.effectiveAppearance.name == .darkAqua
        let backgroundColor = isDarkMode ? NSColor.gray : NSColor.white
        view.layer?.backgroundColor = backgroundColor.withAlphaComponent(0.8).cgColor
                
        view.layer?.shadowColor = NSColor.black.cgColor
        view.layer?.shadowOpacity = isDarkMode ? 0.3 : 0.2
        view.layer?.shadowOffset = CGSize(width: 0, height: -2)
        view.layer?.shadowRadius = 4
        
        return view
    }
    
    func createPositionBasedIconView(for containerFrame: NSRect) -> NSImageView {
        // 위치별 아이콘 프레임 계산
        let iconFrame = getIconPosition(for: containerFrame)
        let iconView = NSImageView(frame: iconFrame)
        
        // 위치별 아이콘 이미지 설정
        iconView.image = getIconImage(for: currentPosition)
        
        // 다크모드에 따른 아이콘 색상 설정
        let isDarkMode = NSApp.effectiveAppearance.name == .darkAqua
        iconView.contentTintColor = isDarkMode ? .white : .black
        
        return iconView
    }
    
    func getIconImage(for position: HotCornerPosition) -> NSImage? {
        let symbolName: String
        
        switch position {
        case .bottomLeft:
            symbolName = "arrow.up.right.circle"
        case .bottomRight:
            symbolName = "arrow.up.left.circle"
        }
        
        return NSImage(systemSymbolName: symbolName, accessibilityDescription: nil)
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
        
        /// 현재 위치에 따른 예상 영역 계산
        let expectedRect = currentPosition.detectionRect(for: screen)
        
        /// 위치가 5픽셀 이상 차이나면 재조정
        if abs(currentFrame.minY - expectedRect.minY) > 5 ||
           abs(currentFrame.minX - expectedRect.minX) > 5 {
            window?.setFrame(expectedRect, display: true)
            updateTrackingArea(for: expectedRect)
        }
    }
}

// MARK: - Animation Methods
private extension HotCornerController {
    func animateWidgetIn() {
        guard let screen = NSScreen.main else { return }
        
        /// 현재 위치에 따른 시작/끝 위치 계산
        let startRect = currentPosition.widgetStartRect(for: screen)
        let endRect = currentPosition.widgetEndRect(for: screen)
        
        window?.setFrame(startRect, display: false)
        window?.level = .floating
        
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
        
        /// 현재 위치에 따른 숨김 위치 계산
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
    
    func resetToDetectionArea() {
        guard let screen = NSScreen.main else { return }
        
        /// 현재 위치에 따른 감지 영역으로 복원
        let detectionRect = currentPosition.detectionRect(for: screen)
        
        window?.setFrame(detectionRect, display: true)
        window?.backgroundColor = .clear
        window?.level = .floating
        window?.contentView?.subviews.removeAll()
        
        updateTrackingArea(for: detectionRect)
    }
    
    /// 위치별 아이콘 위치 계산 메서드
    func getIconPosition(for widgetSize: NSRect) -> NSRect {
        let iconSize: CGFloat = 20
        
        switch currentPosition {
        case .bottomLeft:
            // 왼쪽일 때는 오른쪽 모서리 상단에 붙이기
            return NSRect(
                x: widgetSize.width - iconSize - 8, // 오른쪽에서 8포인트 안쪽
                y: widgetSize.height - iconSize - 8, // 상단에서 8포인트 아래
                width: iconSize,
                height: iconSize
            )
        case .bottomRight:
            // 오른쪽일 때는 왼쪽 모서리 상단에 붙이기
            return NSRect(
                x: 8, // 왼쪽에서 8포인트 안쪽
                y: widgetSize.height - iconSize - 8, // 상단에서 8포인트 아래
                width: iconSize,
                height: iconSize
            )
        }
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
