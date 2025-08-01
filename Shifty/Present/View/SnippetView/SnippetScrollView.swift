//
//  SnippetScrollView.swift
//  QuickSniper
//
//  Created by 이민호 on 5/29/25.
//

import SwiftUI
import Resolver
import SwiftData
import AppKit
import UniformTypeIdentifiers

struct SnippetScrollView: View, DraggableView {    
    @Injected var viewModelContainer: ViewModelContainer
    @StateObject var viewModel: SnippetScrollViewModel
    @State var draggingItem: String?
    @Query var snippets: [Snippet]
        
    init(viewModel: SnippetScrollViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Group {
            if viewModel.items.isEmpty {
                Text(String(localized: "createSnippet"))
                    .foregroundStyle(.gray)
                    .padding()
            }
            
            ForEach(viewModel.items, id: \.id) { snippet in
                SnippetCardView(
                    viewModel: viewModelContainer.getSnippetCardViewModel(snippet: snippet)
                )
                .dragDrop(
                    viewModel: viewModel,
                    draggingItemId: $draggingItem,
                    itemId: snippet.id
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
        .hStackContainer(itemCount: viewModel.items.count) // HStack + 스타일링 한번에!
        .syncQuery(
            viewModel: self.viewModel,
            items: snippets
        )
    }
}

extension SnippetScrollView {
    func getDraggingBinding() -> Binding<String?> {
        return $draggingItem
    }
}

#Preview {
    @Injected var viewModelContainer: ViewModelContainer
    SnippetScrollView(viewModel: viewModelContainer.snippetScrollViewModel)
}
