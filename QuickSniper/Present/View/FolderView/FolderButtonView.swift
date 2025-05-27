//
//  HoverButton.swift
//  QuickSniper
//
//  Created by 이민호 on 5/24/25.
//

import SwiftUI
import Resolver

struct FolderButtonView: View {
    @ObservedObject private var viewModel: FolderButtonViewModel
    @State private var isHovered = false
    private var folder: Folder
    
    private var isSelected: Bool
    private var title: String
        
    private let minWidth: CGFloat = 100
    private let maxWidth: CGFloat = 200
        
    init(
        viewModel: FolderButtonViewModel,
        title: String,
        isSelected: Bool = false,
        folder: Folder
    ) {
        self.viewModel = viewModel
        self.title = title
        self.isSelected = isSelected
        self.folder = folder
    }
    
    var body: some View {
        HStack(spacing: 10) {
            Button {
                
            } label: {
                Text(title)
                    .lineLimit(1)
                    .padding(.vertical, 8)
                    .foregroundColor(isSelected ? Color.point : Color.subText)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, 8)
        .background(isHovered ? Color.cardHover : Color.background)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
                viewModel.setFolder(hovering ? folder : nil)                
            }
        }
        .contextMenu{
            FolderOptionView()
        }
    }
}

#Preview {
    @Injected var viewModelContainer: ViewModelContainer
    
    FolderButtonView(
        viewModel: viewModelContainer.folderButtonViewModel,
        title: "Folder1",
        isSelected: false,
        folder: Folder(name: "", type: .quickLink, order: 1)
    )
    .frame(width: 200, height: 50)
}
