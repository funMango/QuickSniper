//
//  FolderCreateButtonView.swift
//  Shifty
//
//  Created by 이민호 on 6/30/25.
//

import SwiftUI
import Resolver
import SwiftData

struct FolderCreateButtonView: View {
    @StateObject var viewModel: FolderCreateButtonViewModel
    @Query var folders: [Folder]
    
    init(viewModel: FolderCreateButtonViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        HoverIconButton(
            onTap: {
                viewModel.validFolderCount()
            },
            systemName: "plus"
        )
        .syncQuery(viewModel: viewModel, items: folders)
    }
}

#Preview {
    @Injected var viewModelContainer: ViewModelContainer
    FolderCreateButtonView(viewModel: viewModelContainer.folderCreateButtonViewModel)
        .frame(width: 400, height: 300)
}
