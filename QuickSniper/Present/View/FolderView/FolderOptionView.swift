//
//  FolderOptionView.swift
//  QuickSniper
//
//  Created by 이민호 on 5/27/25.
//

import SwiftUI
import Resolver

struct FolderOptionView: View {
    @Injected var viewModelContainer: ViewModelContainer
    
    
    var body: some View {
        VStack {
            EditFolderButtonView(
                viewModel: viewModelContainer.editFolderViewModel
            )
            
            DeleteFolderView(
                viewModel: viewModelContainer.deleteFolderViewModel
            )
        }
    }
}

#Preview {
    FolderOptionView()
}
