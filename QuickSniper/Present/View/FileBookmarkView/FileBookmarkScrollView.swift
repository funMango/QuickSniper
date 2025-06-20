//
//  FileBookmarkScrollView.swift
//  QuickSniper
//
//  Created by 이민호 on 6/15/25.
//

import SwiftUI
import Resolver
import SwiftData

struct FileBookmarkScrollView: View, DraggableView {
    @Injected var viewModelContainer: ViewModelContainer
    @StateObject var viewModel: FileBookmarkScrollViewModel
    @State var draggingItem: String?
    @Query var fileBookmarkItems: [FileBookmarkItem]
    
    init(viewModel: FileBookmarkScrollViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Group {
            if viewModel.items.isEmpty {
                Text(String(localized: "createFileBookmark"))
                    .foregroundStyle(.gray)
            }
            
            ForEach(viewModel.items, id: \.id) { item in
                FileBookmarkCardView(
                    viewModel: viewModelContainer.getFileBookmarkCardViewModel(item: item)
                )                
                .transition(.asymmetric(
                    insertion: .scale.combined(with: .opacity),
                    removal: .scale.combined(with: .opacity)
                ))
                .dragDrop(
                    viewModel: viewModel,
                    draggingItemId: $draggingItem,
                    itemId: item.id
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

extension FileBookmarkScrollView {
    func getDraggingBinding() -> Binding<String?> {
        return $draggingItem
    }
}

//#Preview {
//    FileBookmarkScrollView()
//}
