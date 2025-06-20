import SwiftUI
import AppKit

// 1단계: 세로 휠을 가로 스크롤로 변환하는 커스텀 NSScrollView
class HorizontalWheelScrollView: NSScrollView {
    
}

// 2단계: SwiftUI에서 사용할 NSViewRepresentable
struct HorizontalScrollViewWithVerticalWheel<Content: View>: NSViewRepresentable {
    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSScrollView()
        let hostingView = NSHostingView(rootView: content())
        scrollView.documentView = hostingView
        scrollView.hasHorizontalScroller = true
        scrollView.hasVerticalScroller = false
        scrollView.drawsBackground = false
        scrollView.contentView.postsBoundsChangedNotifications = true
        scrollView.verticalScrollElasticity = .none
        scrollView.horizontalScrollElasticity = .allowed

        hostingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingView.topAnchor.constraint(equalTo: scrollView.contentView.topAnchor),
            hostingView.bottomAnchor.constraint(equalTo: scrollView.contentView.bottomAnchor),
            hostingView.leadingAnchor.constraint(equalTo: scrollView.contentView.leadingAnchor),
            hostingView.widthAnchor.constraint(greaterThanOrEqualTo: scrollView.contentView.widthAnchor, constant: 0.1)
            // width 제약은 생략 (intrinsic width에 맡김)
        ])

        return scrollView
    }

    func updateNSView(_ nsView: NSScrollView, context: Context) {
        if let hostingView = nsView.documentView as? NSHostingView<Content> {
            hostingView.rootView = content()
        }
    }
} 
