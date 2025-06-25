//
//  VisualEffectView.swift
//  QuickSniper
//
//  Created by 이민호 on 5/19/25.
//

import SwiftUI
import AppKit

struct VisualEffectView: NSViewRepresentable {
    var material: NSVisualEffectView.Material
    var blendingMode: NSVisualEffectView.BlendingMode = .behindWindow // 기본값 제공

    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}

// MARK: - Presets (for reuse)
extension VisualEffectView {
    
    /// 기본 HUD 패널 스타일
    static var panel: VisualEffectView {
        VisualEffectView(material: .menu, blendingMode: .behindWindow)
    }
    
    static var panelWithOverlay: some View {
        VisualEffectView(material: .menu, blendingMode: .behindWindow)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color.background.opacity(0.3))
            )
    }
    
    static func panelWithOverlay(backgroundColor: Color) -> some View {
        VisualEffectView(material: .menu, blendingMode: .behindWindow)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(backgroundColor.opacity(0.4))
            )
    }
}
