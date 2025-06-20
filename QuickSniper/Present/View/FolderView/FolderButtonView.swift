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
    @StateObject private var viewModel: FolderButtonViewModel
    @State private var isHovered = false
                    
    init(viewModel: FolderButtonViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        content
            .onHover { hovering in
                withAnimation(.easeInOut(duration: 0.2)) {
                    isHovered = hovering
                }
            }
            .onClick {
                viewModel.changeSelectedFolder()
            }
            .onRightClick {
                viewModel.changeSelectedFolder()
            }
            .contextMenu{
                FolderOptionView()
            }
    }
}

extension FolderButtonView {
    private var content: some View {
        HStack(spacing: 10) {
            FolderButtonContentView(
                viewModel: viewModelContainer.getFolderButtonContentViewModel(
                    folder: viewModel.folder
                ),
                isSelected: viewModel.isSelected                
            )
        }
        .padding(.horizontal, 8)
        .background {
            Group {
                if viewModel.isSelected {
                    VisualEffectView.panelWithOverlay
                } else if isHovered {
                    Color.buttonHover
                } else {
                    Color.clear
                }
            }
        }
        .cornerRadius(10)
    }
}

#Preview {
    @Injected var viewModelContainer: ViewModelContainer
    let folder = Folder(name: "folder", type: .fileBookmark, order: 0)
    
    FolderButtonView(
        viewModel: viewModelContainer.getFolderButtonViewModel(folder: folder)
    )
    .frame(width: 200, height: 50)
}
