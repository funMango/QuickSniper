//
//  FolderView.swift
//  QuickSniper
//
//  Created by 이민호 on 5/23/25.
//

import SwiftUI
import SwiftData

struct FolderView: View {
    @Query var folders: [Folder]
    @State private var selectedFolder: Folder?

    var body: some View {
        HStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(folders, id: \.self) { folder in
                        HoverButton(
                            onTap: {
                                selectedFolder = folder
                            },
                            title: folder.name,
                            isSelected: selectedFolder == folder
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
