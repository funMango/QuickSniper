//
//  DoubleClickable.swift
//  QuickSniper
//
//  Created by 이민호 on 6/10/25.
//

import Foundation
import SwiftUI

private struct DoubleClickModifier: ViewModifier {
    let onDoubleClick: () -> Void

    func body(content: Content) -> some View {
        DoubleClickableView(onDoubleClick: onDoubleClick) {
            content
        }
    }
}

extension View {    
    func onDoubleClick(perform action: @escaping () -> Void) -> some View {
        self.modifier(DoubleClickModifier(onDoubleClick: action))
    }
}


struct DoubleClickableView<Content: View>: NSViewRepresentable {
    let onDoubleClick: () -> Void
    let content: () -> Content

    func makeNSView(context: Context) -> NSHostingView<Content> {
        let hostingView = NSHostingView(rootView: content())
        let gesture = NSClickGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.doubleClicked)
        )
        gesture.numberOfClicksRequired = 2
        hostingView.addGestureRecognizer(gesture)
        return hostingView
    }

    func updateNSView(_ nsView: NSHostingView<Content>, context: Context) {
        nsView.rootView = content()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(onDoubleClick: onDoubleClick)
    }

    class Coordinator: NSObject {
        let onDoubleClick: () -> Void
        init(onDoubleClick: @escaping () -> Void) {
            self.onDoubleClick = onDoubleClick
        }

        @objc func doubleClicked() {
            onDoubleClick()
        }
    }
}
