//
//  FolderView.swift
//  QuickSniper
//
//  Created by 이민호 on 5/23/25.
//

import SwiftUI

struct FolderView: View {
    let folders: [String]
    @Binding var selectedFolder: String?
    
    
    var body: some View {
        HStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(folders, id: \.self) { folder in
                        HoverButton(
                            onTap: { selectedFolder = folder },
                            title: folder,
                            isSelected: selectedFolder == folder
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
    @Previewable @State var selectedFolder: String? = "Documents"
    
    return FolderView(
        folders: ["Documents", "Downloads", "Pictures", "Music", "Videos"],
        selectedFolder: $selectedFolder        
    )
}
