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
        HStack {
            CoreModelScrollView(
                viewModel: viewModelContainer.coreModelScrollViewModel
            )
            
            Spacer()
            
            VStack {
                Spacer()
                ItemPlusButtonView(
                    viewModel: viewModelContainer.itemPlusButtonViewModel,
                    systemName: "plus",
                    size: 30
                )
                Spacer()
            }
        }        
        .frame(height: 150)
        .padding(.horizontal)
    }
}


//        HStack {
//            switch viewModel.selectedFolder?.type {
//            case .snippet:
//                SnippetScrollView(
//                    viewModel: viewModelContainer.snippetScrollViewModel
//                )
//            case .fileBookmark:
//                FileBookmarkScrollView(
//                    viewModel: viewModelContainer.fileBookmarkScrollViewModel
//                )
//            case .all:
//                CoreModelScrollView()
//
//            case .none:
//                Text("")
//            }
//        }
