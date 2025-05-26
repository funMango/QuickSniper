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
    
    var body: some View {
        HStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(folders, id: \.self) { folder in
                        HoverButton(
                            onTap: {},
                            title: folder.name,
                            isSelected: true
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
    FolderView()
}
