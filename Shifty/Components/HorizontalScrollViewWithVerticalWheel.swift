//  HorizontalWheelScrollView.swift
//  QuickSniper
//
//  Created by 이민호 on 6/15/25.
//

import SwiftUI
import AppKit

class HorizontalWheelScrollView: NSScrollView {
    override func scrollWheel(with event: NSEvent) {
        let deltaY = event.deltaY
        let deltaX = event.deltaX
        
        if abs(deltaY) > 0 && abs(deltaX) < 0.1 {
            let currentPoint = contentView.bounds.origin
                        
            let scrollAmount = deltaY * 5.0
            let newX = currentPoint.x - scrollAmount
                        
            contentView.setBoundsOrigin(NSPoint(x: newX, y: currentPoint.y))
            reflectScrolledClipView(contentView)
                        
            flashScrollers()
        } else {
            super.scrollWheel(with: event)
        }
    }
}

struct HorizontalScrollViewWithVerticalWheel<Content: View>: NSViewRepresentable {
    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    func makeNSView(context: Context) -> HorizontalWheelScrollView {
        let scrollView = HorizontalWheelScrollView()
        let hostingView = NSHostingView(rootView: content())
                
        scrollView.hasHorizontalScroller = true
        scrollView.hasVerticalScroller = false
        scrollView.drawsBackground = false
        scrollView.verticalScrollElasticity = .none
        scrollView.horizontalScrollElasticity = .allowed
                
        scrollView.autohidesScrollers = true
        scrollView.scrollerStyle = .overlay
        scrollView.scrollerKnobStyle = .default
                
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.documentView = hostingView
        
        NSLayoutConstraint.activate([
            hostingView.topAnchor.constraint(equalTo: scrollView.contentView.topAnchor),
            hostingView.bottomAnchor.constraint(equalTo: scrollView.contentView.bottomAnchor),
            hostingView.leadingAnchor.constraint(equalTo: scrollView.contentView.leadingAnchor)            
        ])
        
        return scrollView
    }

    func updateNSView(_ nsView: HorizontalWheelScrollView, context: Context) {
        if let hostingView = nsView.documentView as? NSHostingView<Content> {
            hostingView.rootView = content()
        }
    }
}
