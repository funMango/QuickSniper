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

    init(subject: PassthroughSubject<ControllerMessage, Never>) {
        self.subject = subject
        super.init(window: nil)

        let hosting = makeHostingView()
        let contentHeight = hosting.fittingSize.height
        let initialFrame = PanelController.makeInitialFrame(height: contentHeight)
        let panel = PanelController.makePanel(with: hosting, frame: initialFrame)

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
            if self?.isPanelVisible == true {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self?.updatePanelSizeAndPosition()
                }
            }
        }
    }

    private func startDockHeightMonitoring() {
        print("고정 위치 모드 - 모니터링 비활성화")
    }

    private func stopDockHeightMonitoring() {
        print("고정 위치 모드 - 정리 완료")
    }

    private func getMaxDockHeight(screen: NSScreen) -> CGFloat {
        return 100
    }

    private func getMaxSideDockWidth(screen: NSScreen) -> CGFloat {
        return 120
    }

    private func getSafePanelHeight(screen: NSScreen) -> CGFloat {
        let maxDockHeight = getMaxDockHeight(screen: screen)
        let extraSafetyMargin: CGFloat = 20
        return maxDockHeight + extraSafetyMargin
    }

    private func getSafePanelWidth(screen: NSScreen) -> CGFloat {
        let fullWidth = screen.frame.width
        let maxSideDockWidth = getMaxSideDockWidth(screen: screen)
        let horizontalMargin: CGFloat = 30
        let extraSafetyMargin: CGFloat = 20
        let safeWidth = fullWidth - (maxSideDockWidth * 2) - (horizontalMargin * 2) - (extraSafetyMargin * 2)
        return max(safeWidth, 600)
    }

    private func updatePanelSizeAndPosition() {
        guard let window = self.window, isPanelVisible else { return }
        guard let screen = NSScreen.main else { return }

        let targetFrame = calculatePanelFrame(screen: screen)

        if abs(window.frame.origin.y - targetFrame.origin.y) > 1 ||
            abs(window.frame.width - targetFrame.width) > 1 ||
            abs(window.frame.origin.x - targetFrame.origin.x) > 1 {
            NSAnimationContext.runAnimationGroup { context in
                context.duration = 0.2
                context.timingFunction = CAMediaTimingFunction(name: .easeOut)
                window.animator().setFrame(targetFrame, display: true)
            }
        }
    }

    private func calculatePanelFrame(screen: NSScreen) -> NSRect {
        let panelHeight = window?.frame.height ?? 100
        let safeBottomMargin = getSafePanelHeight(screen: screen)
        let safeWidth = getSafePanelWidth(screen: screen)
        let x = (screen.frame.width - safeWidth) / 2
        let y = safeBottomMargin
        return NSRect(x: x, y: y, width: safeWidth, height: panelHeight)
    }

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

    private func showPanel() {
        guard let window = self.window, !isPanelVisible else { return }
        guard let screen = NSScreen.main else { return }

        isManualHide = false

        let targetFrame = calculatePanelFrame(screen: screen)
        let startFrame = NSRect(
            x: targetFrame.origin.x,
            y: targetFrame.origin.y,
            width: targetFrame.width,
            height: targetFrame.height
        )

        window.setFrame(startFrame, display: false)
        window.alphaValue = 0
        window.orderFront(nil)
        window.makeKey()

        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.25
            context.timingFunction = CAMediaTimingFunction(name: .easeOut)
            window.animator().alphaValue = 1
        }

        isManualHide = false
        isPanelVisible = true
        allowAutoHide = true
        startDockHeightMonitoring()
        subject.send(.panelStatus(true))
    }

    private func performHidePanel() {
        guard let window = self.window, isPanelVisible else { return }

        stopDockHeightMonitoring()

        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.25
            context.timingFunction = CAMediaTimingFunction(name: .easeIn)
            window.animator().alphaValue = 0
        }, completionHandler: {
            window.orderOut(nil)
        })

        isPanelVisible = false
        subject.send(.panelStatus(false))
    }

    private func forceFocus() {
        guard let window = self.window else { return }

        window.orderFrontRegardless()
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
        return NSHostingView(rootView: view)
    }

    private static func makeInitialFrame(height: CGFloat) -> NSRect {
        let screen = NSScreen.main?.frame ?? NSRect(x: 0, y: 0, width: 1920, height: 1080)
        let maxDockHeight: CGFloat = 100
        let maxSideDockWidth: CGFloat = 120
        let extraSafetyMargin: CGFloat = 20
        let safeBottomMargin = maxDockHeight + extraSafetyMargin
        let horizontalMargin: CGFloat = 30
        let safeWidth = screen.width - (maxSideDockWidth * 2) - (horizontalMargin * 2) - (extraSafetyMargin * 2)
        let finalWidth = max(safeWidth, 600)
        let x = (screen.width - finalWidth) / 2
        let y = safeBottomMargin
        return NSRect(x: x, y: y, width: finalWidth, height: height)
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
