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
            HStack {
                ItemPlusButtonView(
                    viewModel: viewModelContainer.itemPlusButtonViewModel,
                    systemName: "plus",
                    size: 30
                )
                .padding(.leading, 5)
            }
        }
        .frame(height: 160)
    }
}

#Preview {
    @Injected var viewModelContainer: ViewModelContainer
    ItemScrollView(
        viewModel: viewModelContainer.itemScrollViewModel
    )
}
