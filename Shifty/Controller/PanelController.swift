import SwiftUI
import AppKit
import Combine
import Resolver
import SwiftData

class PanelController: NSWindowController, NSWindowDelegate {
    @Injected var viewModelContainer: ViewModelContainer
    private var allowAutoHide: Bool = true
    private var isPanelVisible = false
    private var subject: PassthroughSubject<ControllerMessage, Never>
    private var cancellables = Set<AnyCancellable>()
    private var isManualHide: Bool = false

    private var dockObserver: NSObjectProtocol?
    
    // 캐시된 프레임 정보
    private var calculatedFrame: NSRect?
    private var currentScreen: NSScreen?
    
    // 업데이트 중복 방지 및 애니메이션 상태 추적
    private var isUpdating = false
    private var isAnimating = false
    
    // 간단한 디바운싱 (타이머 없이)
    private var lastActionTime: Date = Date.distantPast

    init(subject: PassthroughSubject<ControllerMessage, Never>) {
        self.subject = subject
        super.init(window: nil)
        let hosting = makeHostingView()
        let contentHeight: CGFloat = 264
        let initialFrame = PanelController.makeInitialFrame(height: contentHeight)
        let initialWidth: CGFloat = initialFrame.width
        let panel = PanelController.makePanel(with: hosting, frame: initialFrame)
        subject.send(.switchPanelWidth(initialWidth))
        
        self.window = panel
        panel.delegate = self
        configurePanel(panel)
        setupBindings()
        setupDockObserver()
    }

    required init?(coder: NSCoder) {
        fatalError("PanelController does not support Storyboard/XIB initialization. Use init(subject:) instead.")
    }

    deinit {
        if let observer = dockObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    private func setupDockObserver() {
        dockObserver = NotificationCenter.default.addObserver(
            forName: NSApplication.didChangeScreenParametersNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            // 화면 변경시에만 캐시 무효화
            self?.invalidateFrameCache()
            
            if self?.isPanelVisible == true {
                self?.performFrameUpdate()
            }
        }
    }
    
    private func invalidateFrameCache() {
        calculatedFrame = nil
        currentScreen = nil
    }

    // 실제 독 높이 계산
    private func getRealDockHeight(screen: NSScreen) -> CGFloat {
        let visibleFrame = screen.visibleFrame
        let fullFrame = screen.frame
        let bottomDockHeight = visibleFrame.origin.y - fullFrame.origin.y
        return max(bottomDockHeight, 0)
    }

    // 실제 독 너비 계산 (좌/우 독)
    private func getRealDockWidth(screen: NSScreen) -> CGFloat {
        let visibleFrame = screen.visibleFrame
        let fullFrame = screen.frame
        let leftDockWidth = visibleFrame.origin.x - fullFrame.origin.x
        let rightDockWidth = fullFrame.maxX - visibleFrame.maxX
        return max(leftDockWidth, rightDockWidth, 0)
    }

    private func getSafePanelHeight(screen: NSScreen) -> CGFloat {
        let realDockHeight = getRealDockHeight(screen: screen)
        let minDockHeight: CGFloat = 80 // 독이 숨겨져도 최소 여백 확보
        let extraSafetyMargin: CGFloat = 20
        return max(realDockHeight, minDockHeight) + extraSafetyMargin
    }

    private func getSafePanelWidth(screen: NSScreen) -> CGFloat {
        let fullWidth = screen.frame.width
        let realDockWidth = getRealDockWidth(screen: screen)
        let minSideDockWidth: CGFloat = 60 // 좌/우 독이 숨겨져도 최소 여백
        let horizontalMargin: CGFloat = 30
        let extraSafetyMargin: CGFloat = 20
        
        let effectiveDockWidth = max(realDockWidth, minSideDockWidth)
        let safeWidth = fullWidth - (effectiveDockWidth * 2) - (horizontalMargin * 2) - (extraSafetyMargin * 2)
        return max(safeWidth, 600)
    }

    private func getOrCalculateFrame(screen: NSScreen) -> NSRect {
        // 같은 화면이고 캐시된 프레임이 있으면 재사용
        // 단, 독 상태가 변경될 수 있으므로 visibleFrame도 비교
        if let cached = calculatedFrame,
           let cachedScreen = currentScreen,
           cachedScreen.frame.equalTo(screen.frame) &&
           cachedScreen.visibleFrame.equalTo(screen.visibleFrame) {
            return cached
        }
        
        // 새로운 프레임 계산
        let frame = calculatePanelFrame(screen: screen)
        calculatedFrame = frame
        currentScreen = screen
        return frame
    }

    private func performFrameUpdate() {
        // 중복 호출 방지
        guard !isUpdating else { return }
        // 애니메이션 중이면 무시 (기존 애니메이션 완료 후 처리)
        guard !isAnimating else { return }
        
        isUpdating = true
        defer { isUpdating = false }
        
        guard let window = self.window, isPanelVisible else { return }
        guard let screen = NSScreen.main else { return }

        let targetFrame = getOrCalculateFrame(screen: screen)
        let currentFrame = window.frame

        // 프레임이 실제로 변경되었을 때만 업데이트 (임계값 사용)
        let threshold: CGFloat = 2.0 // 2픽셀 이상 차이날 때만 업데이트
        if abs(currentFrame.origin.y - targetFrame.origin.y) > threshold ||
            abs(currentFrame.width - targetFrame.width) > threshold ||
            abs(currentFrame.origin.x - targetFrame.origin.x) > threshold {
            
            isAnimating = true
            
            // 간단한 애니메이션으로 변경
            DispatchQueue.main.async { [weak self] in
                guard let self = self, let window = self.window else {
                    self?.isAnimating = false
                    return
                }
                
                // 직접 setFrame 호출 (애니메이션 없이)
                window.setFrame(targetFrame, display: true)
                self.isAnimating = false
            }
        }
    }

    private func updatePanelSizeAndPosition() {
        performFrameUpdate()
    }

    private func calculatePanelFrame(screen: NSScreen) -> NSRect {
        let panelHeight = window?.frame.height ?? 264 // 현재 패널의 높이를 유지하거나 기본값 사용
        let targetWidth = screen.frame.width * 0.8 // 화면 너비의 80%
        let x = (screen.frame.width - targetWidth) / 2 // 중앙 정렬
        let y = screen.frame.height * 0.1 // 화면 하단에서 30% 높이
        
        return NSRect(x: x, y: y, width: targetWidth, height: panelHeight)
    }

    func toggle() {
        guard shouldAllowAction() else { return }
        isPanelVisible ? performHidePanel() : showPanel()
    }

    func hidePanel() {
        guard shouldAllowAction() else { return }
        isManualHide = true
        performHidePanel()
    }

    func AutoHidePanel() {
        guard shouldAllowAction() else { return }
        performHidePanel()
    }
    
    private func shouldAllowAction() -> Bool {
        let now = Date()
        let timeSinceLastAction = now.timeIntervalSince(lastActionTime)
        
        // 0.2초 내의 연속 호출 방지
        guard timeSinceLastAction > 0.2 else { return false }
        
        lastActionTime = now
        return true
    }

    private func showPanel() {
        guard let window = self.window, !isPanelVisible else { return }
        guard let screen = NSScreen.main else { return }

        isManualHide = false

        let targetFrame = getOrCalculateFrame(screen: screen)

        // 단순한 방식으로 변경
        window.setFrame(targetFrame, display: false)
        window.alphaValue = 0
        window.orderFront(nil)
        window.makeKey()

        // 알파 애니메이션만 사용
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.25
            context.timingFunction = CAMediaTimingFunction(name: .easeOut)
            window.animator().alphaValue = 1
        })

        isPanelVisible = true
        allowAutoHide = true
        subject.send(.panelStatus(true))
    }

    private func performHidePanel() {
        guard let window = self.window, isPanelVisible else { return }
        
        isAnimating = true
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.25
            context.timingFunction = CAMediaTimingFunction(name: .easeIn)
            window.animator().alphaValue = 0
        }, completionHandler: { [weak self] in
            window.orderOut(nil)
            self?.isAnimating = false
        })

        isPanelVisible = false
        subject.send(.panelStatus(false))
    }

    private func forceFocus() {
        guard let window = self.window else { return }

        window.orderFront(nil)
        window.makeKey()
        window.makeMain()

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

    private func configurePanel(_ panel: ShiftyPanel) {
        panel.level = .floating
        panel.collectionBehavior = [
            .moveToActiveSpace,
            .fullScreenAuxiliary,
            .ignoresCycle
        ]
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

    private func makeHostingView() -> NSHostingView<some View> {
        let modelContext = Resolver.resolve(ModelContext.self)
        let view = PanelView(viewModel: viewModelContainer.panelViewModel)
            .environment(\.modelContext, modelContext)
        
        let hostingView = NSHostingView(rootView: view)
        
        // 가장 안전한 설정: 기본 동작 유지
        return hostingView
    }

    private static func makeInitialFrame(height: CGFloat) -> NSRect {
        guard let screen = NSScreen.screens.first else { // NSScreen.main 대신 첫 번째 화면을 시도
            // Fallback: Default to a reasonable size centered on a hypothetical screen
            let defaultScreenSize = NSScreen.main?.frame.size ?? CGSize(width: 1920, height: 1080)
            let defaultWidth: CGFloat = defaultScreenSize.width * 0.8 // 화면 너비의 80%
            let defaultX = (defaultScreenSize.width - defaultWidth) / 2
            let defaultY = defaultScreenSize.height * 0.3 // 화면 하단에서 30% 높이
            return NSRect(x: defaultX, y: defaultY, width: defaultWidth, height: height)
        }
        
        // 실제 화면 정보를 기반으로 프레임 계산
        let fullFrame = screen.frame
        let targetWidth: CGFloat = fullFrame.width * 0.8 // 화면 너비의 80%
        let targetHeight: CGFloat = height // 기존 높이 유지
        
        let x = (fullFrame.width - targetWidth) / 2 // 중앙 정렬
        let y = fullFrame.height * 0.3 // 화면 하단에서 30% 높이
        
        return NSRect(x: x, y: y, width: targetWidth, height: targetHeight)
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

class ShiftyPanel: NSPanel {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }

    override func keyDown(with event: NSEvent) {
        super.keyDown(with: event)
    }
}
