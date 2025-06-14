//
//  ToastView.swift
//  QuickSniper
//
//  Created by 이민호 on 6/13/25.
//

import SwiftUI

struct ToastView: View {
    let toast: ToastMessage
    
    var body: some View {
        HStack(spacing: 12) {
            Text(toast.type.emoji)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(toast.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
                
                if let message = toast.message {
                    Text(message)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            VisualEffectView.panelWithOverlay
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(.quaternary, lineWidth: 1)
        )
    }
}

#Preview {
    ToastView(toast: .copySuccess(snippetTitle: "스니펫 제목"))
        .padding()
}
