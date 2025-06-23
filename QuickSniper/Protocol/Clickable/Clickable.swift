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
            .simultaneousGesture(
                TapGesture(count: 2)
                    .onEnded { _ in
                        doubleAction()
                    }
            )
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
            .simultaneousGesture(
                TapGesture(count: 2)
                    .onEnded { _ in
                        doubleAction()
                    }
            )
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
    
    init(rootView: Content, onClick: @escaping () -> Void, onDoubleClick: (() -> Void)? = nil, onRightClick: (() -> Void)? = nil) {
        self.onClick = onClick
        self.onDoubleClick = onDoubleClick
        self.onRightClick = onRightClick
        super.init(rootView: rootView)
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @available(*, unavailable)
    required init(rootView: Content) {
        self.onClick = { }
        self.onDoubleClick = nil
        self.onRightClick = nil
        super.init(rootView: rootView)
    }
    
    required init?(coder: NSCoder) {
        self.onClick = { }
        self.onDoubleClick = nil
        self.onRightClick = nil
        super.init(coder: coder)
    }
    
    override func rightMouseDown(with event: NSEvent) {
        onRightClick?()
        super.rightMouseDown(with: event)
    }
    
    override func mouseDown(with event: NSEvent) {
        // 더블클릭은 SwiftUI simultaneousGesture가 처리
        // 여기서는 싱글클릭만 처리 (즉시 실행)
        onClick()
        
        super.mouseDown(with: event)
    }
}
