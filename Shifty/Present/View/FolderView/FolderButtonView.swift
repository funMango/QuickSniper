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
            .onClick(
                perform: {
                    viewModel.changeSelectedFolder()
                },
                onRightClick: {
                    viewModel.changeSelectedFolder()
                }
            )
            .onHover { hovering in
                withAnimation(.easeInOut(duration: 0.2)) {
                    isHovered = hovering
                }
            }            
            .contextMenu{
                FolderOptionView()
            }
    }
}

extension FolderButtonView {
    private var content: some View {
        FolderButtonContentView(
            viewModel: viewModelContainer.getFolderButtonContentViewModel(
                folder: viewModel.folder
            ),
            isSelected: viewModel.isSelected
        )
        .pillStyleBackground(isSelected: $viewModel.isSelected, color: .block)
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
