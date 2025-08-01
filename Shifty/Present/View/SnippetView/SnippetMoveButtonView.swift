//
//  SnippetMoveButtonView.swift
//  QuickSniper
//
//  Created by 이민호 on 6/9/25.
//

import SwiftUI
import Resolver
import SwiftData


struct SnippetMoveButtonView: View {
    @StateObject var viewModel: SnippetMoveButtonViewModel
    @Query var folders: [Folder]
    
    init(viewModel: SnippetMoveButtonViewModel) {
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
