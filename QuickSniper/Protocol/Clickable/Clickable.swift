//
//  Clickable.swift
//  QuickSniper
//
//  Created by 이민호 on 6/10/25.
//

import Foundation
import SwiftUI

private struct ClickModifier: ViewModifier {
    let onClick: () -> Void

    func body(content: Content) -> some View {
        ClickableView(onClick: onClick) {
            content
        }
    }
}

extension View {
    func onClick(perform action: @escaping () -> Void) -> some View {
        self.modifier(ClickModifier(onClick: action))
    }
}

struct ClickableView<Content: View>: NSViewRepresentable {
    let onClick: () -> Void
    let content: () -> Content

    func makeNSView(context: Context) -> NSHostingView<Content> {
        let hostingView = NSHostingView(rootView: content())
        let gesture = NSClickGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.clicked))
        gesture.numberOfClicksRequired = 1
        hostingView.addGestureRecognizer(gesture)
        return hostingView
    }

    func updateNSView(_ nsView: NSHostingView<Content>, context: Context) {
        nsView.rootView = content()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(onClick: onClick)
    }

    class Coordinator: NSObject {
        let onClick: () -> Void
        init(onClick: @escaping () -> Void) {
            self.onClick = onClick
        }

        @objc func clicked() {
            onClick()
        }
    }
}
