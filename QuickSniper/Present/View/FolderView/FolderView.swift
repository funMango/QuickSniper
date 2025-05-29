//
//  FolderView.swift
//  QuickSniper
//
//  Created by 이민호 on 5/23/25.
//

import SwiftUI
import SwiftData
import Resolver

struct FolderView: View {
    @Injected var viewModelContainer: ViewModelContainer
    @ObservedObject var viewModel: FolderViewModel
    @Query var folders: [Folder]

    var body: some View {
        HStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(folders, id: \.self) { folder in
                        FolderButtonView(
                            viewModel: viewModelContainer.folderButtonViewModel,
                            title: folder.name,
                            isSelected: viewModel.selectedFolder == folder,
                            folder: folder,
                            onTap: { viewModel.selectedFolder = folder }
                        )
                    }
                }
            }
        }
        .fixedSize()
        .frame(height: 40)
        .background(Color.background)        
    }
}

#Preview {
    @Injected var viewModelContainer: ViewModelContainer
    FolderView(viewModel: viewModelContainer.folderViewModel)
}
