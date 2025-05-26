//
//  HoverButton.swift
//  QuickSniper
//
//  Created by 이민호 on 5/24/25.
//

import SwiftUI

struct HoverButton: View {
    @State private var isHovered = false
    private let onTap: () -> Void
    private var title: String
    private let isSelected: Bool
    
    private let minWidth: CGFloat = 100
    private let maxWidth: CGFloat = 200
        
    init(onTap: @escaping () -> Void, title: String, isSelected: Bool = false) {
        self.onTap = onTap
        self.title = title
        self.isSelected = isSelected
    }
    
    var body: some View {
        Button(action: onTap) {
            Text(title)
                .lineLimit(1)                                
                .padding(.vertical, 8)
                .foregroundColor((isHovered || isSelected) ? Color.point : Color.subText)
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
        }
    }
}

#Preview {
    HoverButton(onTap: {}, title: "Folder1", isSelected: false)
}
