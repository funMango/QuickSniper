//
//  RightClickable.swift
//  QuickSniper
//
//  Created by 이민호 on 6/10/25.
//

import SwiftUI
import AppKit

private struct RightClickModifier: ViewModifier {
    let onRightClick: () -> Void

    func body(content: Content) -> some View {
        RightClickableView(onRightClick: onRightClick) {
            content
        }
    }
}

extension View {
    func onRightClick(perform action: @escaping () -> Void) -> some View {
        self.modifier(RightClickModifier(onRightClick: action))
    }
}

struct RightClickableView<Content: View>: NSViewRepresentable {
    let onRightClick: () -> Void
    let content: () -> Content

    func makeNSView(context: Context) -> CustomHostingView<Content> {
        let view = CustomHostingView(rootView: content(), onRightClick: onRightClick)
        return view
    }

    func updateNSView(_ nsView: CustomHostingView<Content>, context: Context) {
        nsView.rootView = content()
    }    
}

class CustomHostingView<Content: View>: NSHostingView<Content> {
    let onRightClick: () -> Void
    
    init(rootView: Content, onRightClick: @escaping () -> Void) {
        self.onRightClick = onRightClick
        super.init(rootView: rootView)
    }
    
    @available(*, unavailable)
    required init(rootView: Content) {
        fatalError("init(rootView:) has not been implemented")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func rightMouseDown(with event: NSEvent) {
        onRightClick() // 커스텀 액션 먼저 실행
        super.rightMouseDown(with: event) // contextMenu도 실행되도록
    }
}

