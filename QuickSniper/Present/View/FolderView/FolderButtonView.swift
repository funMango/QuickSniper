//
//  HoverButton.swift
//  QuickSniper
//
//  Created by 이민호 on 5/24/25.
//

import SwiftUI
import Resolver

struct FolderButtonView: View {
    @Injected var controllerContainer: ControllerContainer
    @Injected var viewModelContainer: ViewModelContainer
    @ObservedObject private var viewModel: FolderButtonViewModel
    @State private var isHovered = false
    @State private var globalFrame: CGRect = .zero
    @State private var isRenaming = false
    private var folder: Folder
    
    private var isSelected: Bool
    private var title: String
    private let onTap: () -> Void
        
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
            RenameableButton(
                viewModel: viewModelContainer.getRenameableButtonViewModel(folder: folder),
                isSelected: isSelected,
                title: title,
                onTap: onTap
            )
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

struct SampleButtonView: View {
    private var isSelected: Bool
    private var title: String
    private let onTap: () -> Void
    
    init(isSelected: Bool, title: String, onTap: @escaping () -> Void) {
        self.isSelected = isSelected
        self.title = title
        self.onTap = onTap
    }
    
    var body: some View {
        Button {
            onTap()
        } label: {
            Text(title)
                .lineLimit(1)
                .padding(.vertical, 8)
                .foregroundColor(isSelected ? Color.point : Color.subText)
        }
        .buttonStyle(PlainButtonStyle())
    }
}


#Preview {
    @Injected var viewModelContainer: ViewModelContainer
    
    FolderButtonView(
        viewModel: viewModelContainer.folderButtonViewModel,
        title: "Folder1",
        isSelected: false,
        folder: Folder(name: "", type: .quickLink, order: 1),
        onTap: {}
    )
    .frame(width: 200, height: 50)
}
