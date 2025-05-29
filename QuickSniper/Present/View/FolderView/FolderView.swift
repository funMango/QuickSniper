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
    @Query var folders: [Folder]
    @State private var selectedFolder: Folder?
    @Injected var viewModelContainer: ViewModelContainer

    var body: some View {
        HStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(folders, id: \.self) { folder in
                        FolderButtonView(
                            viewModel: viewModelContainer.folderButtonViewModel,
                            title: folder.name,
                            isSelected: selectedFolder == folder,
                            folder: folder,
                            onTap: { selectedFolder = folder }
                        )
                    }
                }
            }
        }
        .fixedSize()
        .frame(height: 40)
        .background(Color.background)
        .onAppear {
            if selectedFolder == nil {
                selectedFolder = folders.first
            }
        }
    }
}

#Preview {
    FolderView()
}
