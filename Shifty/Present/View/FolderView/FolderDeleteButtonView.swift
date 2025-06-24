//
//  DeleteFolderView.swift
//  QuickSniper
//
//  Created by 이민호 on 5/27/25.
//

import SwiftUI
import Resolver

struct FolderDeleteButtonView: View {
    @ObservedObject var viewModel: FolderDeleteButtonViewModel
            
    var body: some View {
        Button {            
            viewModel.showDeleteFolderAlert()
        } label: {
            OptionButtonStyle(
                systemName: "trash",
                title: "deleteFolder"
            )
        }
    }
}


#Preview {
    @Injected var viewModelContainer: ViewModelContainer
    FolderDeleteButtonView(viewModel: viewModelContainer.folderDeleteButtonViewModel)
}
