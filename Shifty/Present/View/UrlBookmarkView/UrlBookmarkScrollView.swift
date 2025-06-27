//
//  UrlBookmarkView.swift
//  Shifty
//
//  Created by 이민호 on 6/27/25.
//

import SwiftUI
import Resolver
import SwiftData

struct UrlBookmarkScrollView: View {
    @Injected var viewModelContainer: ViewModelContainer
    @StateObject var viewModel: UrlBookmarkScrollViewModel
    @Query var utlBookmarks: [UrlBookmark]
    
    init(viewModel: UrlBookmarkScrollViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Group {
            if viewModel.items.isEmpty {
                Text(String(localized: "createUrlBookmark"))
                    .foregroundStyle(.gray)
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
            viewModel: self.viewModel,
            items: utlBookmarks
        )
    }
}

#Preview {
    @Injected var viewModelContainer: ViewModelContainer
    UrlBookmarkScrollView(viewModel: viewModelContainer.urlBookmarkScrollViewModel)
}
