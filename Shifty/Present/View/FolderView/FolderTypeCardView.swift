import SwiftUI

//
//  FolderView.swift
//  QuickSniper
//
//  Created by 이민호 on 5/23/25.
//

struct FolderTypeCardView: View {
    let folderType: FolderType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button{
            action()
        } label: {
            VStack(spacing: 8) {
                Spacer()
                Image(systemName: folderType.icon)
                    .font(.system(size: 24, weight: .regular))
                    .frame(width: 24, height: 24)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, maxHeight: 30)
                
                Spacer()
                
                Text(folderType.name)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, maxHeight: 32, alignment: .center)
                Spacer()
            }
            .frame(height: 70)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                VisualEffectView.panelWithOverlay
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        isSelected ? Color.accentColor : Color.clear,
                        lineWidth: 2
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())        
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

#Preview {
    VStack(spacing: 16) {
        // 기본 카드
        HStack(spacing: 12) {
            FolderTypeCardView(
                folderType: .snippet,
                isSelected: false,
                action: {}
            )
            
            FolderTypeCardView(
                folderType: .snippet,
                isSelected: true,
                action: {}
            )
        }
    }
    .padding()
}
