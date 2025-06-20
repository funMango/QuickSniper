//  HorizontalWheelScrollView.swift
//  QuickSniper
//
//  Created by 이민호 on 6/15/25.
//

import SwiftUI
import AppKit

// 1단계: 세로 휠을 가로 스크롤로 변환하는 커스텀 NSScrollView
class HorizontalWheelScrollView: NSScrollView {
    
    override func scrollWheel(with event: NSEvent) {
        // 세로 스크롤 델타값 가져오기
        let deltaY = event.deltaY
        let deltaX = event.deltaX
        
        // 세로 스크롤이 있고 가로 스크롤이 없는 경우에만 변환
        if abs(deltaY) > 0 && abs(deltaX) < 0.1 {
            // 현재 스크롤 위치
            let currentPoint = contentView.bounds.origin
            
            // 스크롤 양을 줄여서 자연스럽게
            let scrollAmount = deltaY * 5.0
            let newX = currentPoint.x - scrollAmount
            
            // 부드러운 스크롤을 위해 setBoundsOrigin 사용
            contentView.setBoundsOrigin(NSPoint(x: newX, y: currentPoint.y))
            
            // 스크롤바 갱신
            reflectScrolledClipView(contentView)
            
            // 스크롤바 표시
            flashScrollers()
        } else {
            // 가로 스크롤이나 다른 경우는 그대로 처리
            super.scrollWheel(with: event)
        }
    }
}

// 2단계: SwiftUI에서 사용할 NSViewRepresentable
struct HorizontalScrollViewWithVerticalWheel<Content: View>: NSViewRepresentable {
    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    func makeNSView(context: Context) -> HorizontalWheelScrollView {
        let scrollView = HorizontalWheelScrollView()
        let hostingView = NSHostingView(rootView: content())
        
        // 먼저 기본 설정
        scrollView.hasHorizontalScroller = true
        scrollView.hasVerticalScroller = false
        scrollView.drawsBackground = false
        scrollView.verticalScrollElasticity = .none
        scrollView.horizontalScrollElasticity = .allowed
        
        // 스크롤 바 표시 설정
        scrollView.autohidesScrollers = true
        scrollView.scrollerStyle = .overlay
        scrollView.scrollerKnobStyle = .default
        
        // hostingView 설정
        hostingView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.documentView = hostingView
        
        NSLayoutConstraint.activate([
            hostingView.topAnchor.constraint(equalTo: scrollView.contentView.topAnchor),
            hostingView.bottomAnchor.constraint(equalTo: scrollView.contentView.bottomAnchor),
            hostingView.leadingAnchor.constraint(equalTo: scrollView.contentView.leadingAnchor)
            // width는 intrinsic width에 맡김
        ])
        
        return scrollView
    }

    func updateNSView(_ nsView: HorizontalWheelScrollView, context: Context) {
        if let hostingView = nsView.documentView as? NSHostingView<Content> {
            hostingView.rootView = content()
        }
    }
}
