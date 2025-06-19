//
//  FileBookmarkMoveButtonView.swift
//  QuickSniper
//
//  Created by 이민호 on 6/19/25.
//

import SwiftUI
import SwiftData

struct FileBookmarkMoveButtonView: View {
    @StateObject var viewModel: FileBookmarkMoveButtonViewModel
    @Query var folders: [Folder]
    
    init(viewModel: FileBookmarkMoveButtonViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        FolderMoveButtonView(
            items: viewModel.items,
            onMove: { folder in
                viewModel.moveToFolder(folder)
            }
        )
        .syncQuery(
            viewModel: viewModel,
            items: folders
        )
    }
}

