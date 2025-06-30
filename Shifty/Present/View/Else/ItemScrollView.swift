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
            
            VStack {
                Spacer()
                ItemPlusButtonView(
                    viewModel: viewModelContainer.itemPlusButtonViewModel,
                    systemName: "plus",
                    size: 30
                )
                Spacer()
            }
            .padding(.trailing)
            
            Spacer()
        }        
        .frame(height: 150)
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
