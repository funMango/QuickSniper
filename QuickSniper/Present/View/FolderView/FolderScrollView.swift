//
//  FolderView.swift
//  QuickSniper
//
//  Created by 이민호 on 5/23/25.
//

import SwiftUI
import SwiftData
import Resolver

struct FolderScrollView: View {
    @Injected var viewModelContainer: ViewModelContainer
    @ObservedObject var viewModel: FolderViewModel
    @State var draggingFolder: Folder?
    @Query var folders: [Folder]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(folders, id: \.id) { folder in
                    FolderButtonBackgroundView(
                        viewModel: viewModelContainer.folderButtonViewModel,
                        title: folder.name,
                        isSelected: viewModel.selectedFolder == folder,
                        folder: folder,
                        onTap: { viewModel.selectedFolder = folder }
                    )
                }
            }
        }
        .fixedSize()
        .frame(height: 40)
        .background(Color.clear)
    }
}

#Preview {
    @Injected var viewModelContainer: ViewModelContainer
    FolderScrollView(viewModel: viewModelContainer.folderViewModel)
}
