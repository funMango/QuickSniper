//
//  FileBookmarkRowView.swift
//  QuickSniper
//
//  Created by 이민호 on 6/15/25.
//

import SwiftUI
import Resolver

struct FileBookmarkRowView: View {
    @StateObject var viewModel: FileBookmarkRowViewModel
    
    init(viewModel: FileBookmarkRowViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        HStack {
            PlainButton(
                content: Image(systemName: viewModel.isSelected ? "checkmark.square" : "square"),
                action: { viewModel.isSelected.toggle() }
            )                        
            
            Text(viewModel.item.name)
            
            Spacer()
            
            Text(viewModel.item.type.rawValue)
                .foregroundStyle(.gray)
        }
        .background(.clear)
    }
}

#Preview {
    @Injected var viewModelContainer: ViewModelContainer
    let mockedItem = FileBookmarkItem(
        folderId: "A358B#6",
        name: "bookmark",
        type: .file
    )
        
    FileBookmarkRowView(
        viewModel: viewModelContainer.getFileBookmarkRowViewModel(item: mockedItem)
    )
    .frame(width: 500, height: 400)
    .padding()
}
