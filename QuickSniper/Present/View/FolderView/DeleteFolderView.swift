//
//  DeleteFolderView.swift
//  QuickSniper
//
//  Created by 이민호 on 5/27/25.
//

import SwiftUI
import Resolver

struct DeleteFolderView: View {
    @ObservedObject var viewModel: DeleteFolderViewModel
            
    var body: some View {
        Button {            
            viewModel.deleteFolder()
        } label: {
            FolderMenuItem(
                systemName: "trash",
                title: "deleteFolder"
            )
        }
    }
}


#Preview {
    @Injected var viewModelContainer: ViewModelContainer
    DeleteFolderView(viewModel: viewModelContainer.deleteFolderViewModel)
}
