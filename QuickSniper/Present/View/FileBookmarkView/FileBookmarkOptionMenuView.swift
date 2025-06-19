//
//  FileBookmarkOptionMenuView.swift
//  QuickSniper
//
//  Created by 이민호 on 6/18/25.
//

import SwiftUI
import Resolver

struct FileBookmarkOptionMenuView: View {
    @Injected var viewModelContainer: ViewModelContainer
    
    var body: some View {
        FileBookmarkDeleteButtonView(
            viewModel: viewModelContainer.fileBookmarkDeleteButtonViewModel
        )
        
        FileBookmarkMoveButtonView(
            viewModel: viewModelContainer.fileBookmarkMoveButtonViewModel
        )
    }
}
