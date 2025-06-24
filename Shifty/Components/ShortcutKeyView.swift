//
//  ShortcutKeyView.swift
//  QuickSniper
//

import SwiftUI

struct ShortcutKeyView: View {
    let keyText: String
    let size: KeySize
    
    enum KeySize {
        case small, medium, large
        
        var padding: EdgeInsets {
            switch self {
            case .small:
                return EdgeInsets(top: 4, leading: 6, bottom: 4, trailing: 6)
            case .medium:
                return EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8)
            case .large:
                return EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
            }
        }
        
        var fontSize: CGFloat {
            switch self {
            case .small: return 10
            case .medium: return 12
            case .large: return 14
            }
        }
        
        var cornerRadius: CGFloat {
            switch self {
            case .small: return 4
            case .medium: return 6
            case .large: return 8
            }
        }
    }
    
    init(_ keyText: String, size: KeySize = .medium) {
        self.keyText = keyText
        self.size = size
    }
    
    var body: some View {
        Text(keyText)
            .font(.system(size: size.fontSize, weight: .medium, design: .rounded))
            .foregroundColor(.primary)
            .padding(size.padding)
            .background(
                VisualEffectView.panelWithOverlay
                    .clipShape(RoundedRectangle(cornerRadius: size.cornerRadius, style: .continuous))
            )
    }
}

// MARK: - 단축키 조합 뷰
struct ShortcutComboView: View {
    let shortcut: LocalShortcut
    let keySize: ShortcutKeyView.KeySize
    let spacing: CGFloat
    
    init(shortcut: LocalShortcut, keySize: ShortcutKeyView.KeySize = .medium, spacing: CGFloat = 4) {
        self.shortcut = shortcut
        self.keySize = keySize
        self.spacing = spacing
    }
    
    var body: some View {
        HStack(spacing: spacing) {
            ForEach(shortcut.displayComponents, id: \.self) { component in
                ShortcutKeyView(component, size: keySize)
            }
        }
    }
}

// MARK: - 프리뷰
#Preview {
    VStack(spacing: 20) {
        // 개별 키 예시
        HStack(spacing: 10) {
            ShortcutKeyView("⌘", size: .small)
            ShortcutKeyView("⌘", size: .medium)
            ShortcutKeyView("⌘", size: .large)
        }
        
        // 단축키 조합 예시
        let sampleShortcut = LocalShortcut.create(
            keyCode: 8,
            modifiers: .command,
            action: .copySnippet
        )
        
        VStack(spacing: 10) {
            ShortcutComboView(shortcut: sampleShortcut, keySize: .small)
            ShortcutComboView(shortcut: sampleShortcut, keySize: .medium)
            ShortcutComboView(shortcut: sampleShortcut, keySize: .large)
        }
        
        // 복잡한 단축키 예시
        let complexShortcut = LocalShortcut.create(
            keyCode: 1,
            modifiers: [.command, .shift, .option],
            action: .copySnippet
        )
        
        ShortcutComboView(shortcut: complexShortcut, keySize: .medium, spacing: 6)
    }
    .padding()
    .background(Color.black.opacity(0.1))
}
