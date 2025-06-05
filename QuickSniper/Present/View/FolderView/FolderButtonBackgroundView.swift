//
//  HoverButton.swift
//  QuickSniper
//
//  Created by 이민호 on 5/24/25.
//

import SwiftUI
import Resolver

struct FolderButtonBackgroundView: View {
    @Injected var controllerContainer: ControllerContainer
    @Injected var viewModelContainer: ViewModelContainer
    @ObservedObject private var viewModel: FolderButtonViewModel
    @State private var isHovered = false
    @State private var globalFrame: CGRect = .zero
    @State private var isRenaming = false
    private var folder: Folder
    
    private var isSelected: Bool
    private var title: String
    private var onTap: () -> Void
        
    private let minWidth: CGFloat = 100
    private let maxWidth: CGFloat = 200
        
    init(
        viewModel: FolderButtonViewModel,
        title: String,
        isSelected: Bool = false,
        folder: Folder,
        onTap: @escaping () -> Void
    ) {
        self.viewModel = viewModel
        self.title = title
        self.isSelected = isSelected
        self.folder = folder
        self.onTap = onTap
    }
    
    var body: some View {
        HStack(spacing: 10) {
            FolderButtonView(
                viewModel: viewModelContainer.getRenameableButtonViewModel(folder: folder),
                isSelected: isSelected,
                title: title
            )
        }
        .padding(.horizontal, 8)
        .background {
            Group {
                if isSelected {
                    VisualEffectView.panelWithOverlay
                } else if isHovered {
                    Color.buttonHover
                } else {
                    Color.clear
                }
            }
        }
        .cornerRadius(10)
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
    
    FolderButtonBackgroundView(
        viewModel: viewModelContainer.folderButtonViewModel,
        title: "Folder1",
        isSelected: false,
        folder: Folder(name: "", type: .quickLink, order: 1),
        onTap: {}
    )
    .frame(width: 200, height: 50)
}
