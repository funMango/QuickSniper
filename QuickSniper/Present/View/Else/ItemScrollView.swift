//
//  ItemScrollView.swift
//  QuickSniper
//
//  Created by 이민호 on 6/15/25.
//

import SwiftUI
import Resolver

struct ItemScrollView: View {
    @Injected var viewModelContainer: ViewModelContainer
    @StateObject var viewModel: ItemScrollViewModel
    
    init(viewModel: ItemScrollViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        HorizontalScrollViewWithVerticalWheel {
            switch viewModel.selectedFolder?.type {
            case .snippet:
                SnippetScrollView(
                    viewModel: viewModelContainer.snippetScrollViewModel
                )
            case .fileBookmark:
                FileBookmarkScrollView(
                    viewModel: viewModelContainer.fileBookmarkScrollViewModel
                )
            case .none:
                Text("")
            }
        }
        .frame(height: 160)
    }
}
