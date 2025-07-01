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
            TypeStyleBackground(title: folderType.name, image: folderType.getSymbol(), isSelected: isSelected)
        }
        .buttonStyle(.plain)
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
                folderType: .fileBookmark,
                isSelected: true,
                action: {}
            )
        }
    }
    .padding()
}


