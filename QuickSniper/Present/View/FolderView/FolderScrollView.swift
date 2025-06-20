//
//  FolderView.swift
//  QuickSniper
//
//  Created by 이민호 on 5/23/25.
//

import SwiftUI
import SwiftData
import Resolver

struct FolderScrollView: View, DraggableView {
    @Injected var viewModelContainer: ViewModelContainer
    @StateObject var viewModel: FolderScrollViewModel
    @State var draggingItem: String?
    @Query var folders: [Folder]
    
    init(viewModel: FolderScrollViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(viewModel.items, id: \.id) { folder in
                    FolderButtonView(
                        viewModel: viewModelContainer.getFolderButtonViewModel(folder: folder)
                    )
                    .dragDrop(
                        viewModel: viewModel,
                        draggingItemId: $draggingItem,
                        itemId: folder.id
                    )
                }
            }
        }
        .fixedSize()
        .frame(height: 40)
        .background(Color.clear)
        .syncQuery(
            viewModel: viewModel,
            items: folders
        )
    }
}

extension FolderScrollView {
    func getDraggingBinding() -> Binding<String?> {
        return $draggingItem
    }
}

#Preview {
    @Injected var viewModelContainer: ViewModelContainer
    FolderScrollView(viewModel: viewModelContainer.folderViewModel)
}
