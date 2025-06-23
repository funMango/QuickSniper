//
//  ClickableView.swift
//  QuickSniper
//
//  Created by 이민호 on 6/23/25.
//

import SwiftUI
import AppKit

private struct ClickModifier: ViewModifier {
    let onClick: () -> Void
    let onDoubleClick: (() -> Void)?
    let onRightClick: (() -> Void)?

    func body(content: Content) -> some View {
        ClickableView(onClick: onClick, onDoubleClick: onDoubleClick, onRightClick: onRightClick) {
            content
        }
    }
}

extension View {
    func onClick(perform action: @escaping () -> Void) -> some View {
        self.modifier(ClickModifier(onClick: action, onDoubleClick: nil, onRightClick: nil))
    }
    
    func onClick(
        perform action: @escaping () -> Void,
        onDoubleClick doubleAction: @escaping () -> Void
    ) -> some View {
        self.modifier(ClickModifier(onClick: action, onDoubleClick: doubleAction, onRightClick: nil))
    }
    
    func onClick(
        perform action: @escaping () -> Void,
        onRightClick rightAction: @escaping () -> Void
    ) -> some View {
        self.modifier(ClickModifier(onClick: action, onDoubleClick: nil, onRightClick: rightAction))
    }
    
    func onClick(
        perform action: @escaping () -> Void,
        onDoubleClick doubleAction: @escaping () -> Void,
        onRightClick rightAction: @escaping () -> Void
    ) -> some View {
        self.modifier(ClickModifier(onClick: action, onDoubleClick: doubleAction, onRightClick: rightAction))
    }
}

struct ClickableView<Content: View>: NSViewRepresentable {
    let onClick: () -> Void
    let onDoubleClick: (() -> Void)?
    let onRightClick: (() -> Void)?
    let content: () -> Content

    func makeNSView(context: Context) -> CustomClickHostingView<Content> {
        let view = CustomClickHostingView(
            rootView: content(),
            onClick: onClick,
            onDoubleClick: onDoubleClick,
            onRightClick: onRightClick
        )
        return view
    }

    func updateNSView(_ nsView: CustomClickHostingView<Content>, context: Context) {
        nsView.rootView = content()
    }
}

class CustomClickHostingView<Content: View>: NSHostingView<Content> {
    let onClick: () -> Void
    let onDoubleClick: (() -> Void)?
    let onRightClick: (() -> Void)?
    private var clickTimer: Timer?
    private var clickCount = 0
    
    init(rootView: Content, onClick: @escaping () -> Void, onDoubleClick: (() -> Void)? = nil, onRightClick: (() -> Void)? = nil) {
        self.onClick = onClick
        self.onDoubleClick = onDoubleClick
        self.onRightClick = onRightClick
        super.init(rootView: rootView)
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @available(*, unavailable)
    required init(rootView: Content) {
        fatalError("init(rootView:) has not been implemented")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func mouseDown(with event: NSEvent) {
        handleClick()
        super.mouseDown(with: event)
    }
    
    override func rightMouseDown(with event: NSEvent) {
        onRightClick?()
        super.rightMouseDown(with: event) // contextMenu도 실행되도록
    }
    
    private func handleClick() {
        clickCount += 1
        
        if let onDoubleClick = onDoubleClick {
            // 더블클릭 지원 모드
            if clickCount == 1 {
                // 첫 번째 클릭 - 0.3초 대기
                clickTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { [weak self] _ in
                    if self?.clickCount == 1 {
                        // 싱글 클릭
                        self?.onClick()
                    }
                    self?.clickCount = 0
                }
            } else if clickCount == 2 {
                // 더블 클릭
                clickTimer?.invalidate()
                onDoubleClick()
                clickCount = 0
            }
        } else {
            // 싱글클릭만 지원
            onClick()
            clickCount = 0
        }
    }
}
