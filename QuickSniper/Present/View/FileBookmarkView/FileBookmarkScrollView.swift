//
//  FileBookmarkScrollView.swift
//  QuickSniper
//
//  Created by 이민호 on 6/15/25.
//

import SwiftUI
import Resolver
import SwiftData

struct FileBookmarkScrollView: View {
    @Injected var viewModelContainer: ViewModelContainer
    @StateObject var viewModel: FileBookmarkScrollViewModel
    @Query var fileBookmarkItems: [FileBookmarkItem]
    
    init(viewModel: FileBookmarkScrollViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Group {
            ForEach(viewModel.items, id: \.id) { item in
                FileBookmarkCardView(
                    viewModel: viewModelContainer.getFileBookmarkCardViewModel(item: item)
                )
            }
            
            VStack {
                Spacer()
                ItemPlusButtonView(
                    viewModel: viewModelContainer.itemPlusButtonViewModel,
                    systemName: "plus",
                    size: 30
                )
                Spacer()
            }
            .padding(.leading, 10)
            
        }
        .hStackContainer(itemCount: viewModel.items.count)
        .syncQuery(
            viewModel: self.viewModel, items: fileBookmarkItems
        )
    }
}

//#Preview {
//    FileBookmarkScrollView()
//}
