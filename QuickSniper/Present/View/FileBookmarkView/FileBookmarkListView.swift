//
//  FileBookmarkListView.swift
//  QuickSniper
//
//  Created by 이민호 on 6/15/25.
//

import SwiftUI
import Resolver
import Combine

struct FileBookmarkListView: View {
    @Injected var viewModelcontainer: ViewModelContainer
    @StateObject var viewModel: FileBookmarkListViewModel
    
    init(viewModel: FileBookmarkListViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            if viewModel.items.count == 0{
                Text(String(localized: "chooseSaveFiles"))
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity, maxHeight: 150)
            } else {
                Divider()
                
                ScrollView {
                    VStack(spacing: 5) {
                        ForEach(viewModel.items, id: \.id) { item in
                            FileBookmarkRowView(
                                viewModel: viewModelcontainer.getFileBookmarkRowViewModel(item: item)
                            )
                            Divider()
                        }
                    }
                }
                .frame(maxHeight: 150)
                .scrollContentBackground(.hidden)
            }
                                    
            Divider()
            
            HStack {
                PlainButton(
                    content: Image(systemName: "plus"),
                    action: { viewModel.addFileOrFolder() }
                )
                
                PlainButton(
                    content: Image(systemName: "minus"),
                    action: { viewModel.deleteCheckedItem() }
                )

                Spacer()
            }
            .padding(.vertical, 5)
        }
    }
}

#Preview {
//    let items: [FileBookmarkItem] = [
//        FileBookmarkItem(name: "test-1", type: .file),
//        FileBookmarkItem(name: "test-2", type: .folder),
//        FileBookmarkItem(name: "test-3", type: .file),
//        FileBookmarkItem(name: "test-1", type: .file),
//        FileBookmarkItem(name: "test-2", type: .folder),
//        FileBookmarkItem(name: "test-3", type: .file)
//    ]
    @Injected var viewModelcontainer: ViewModelContainer
    
    FileBookmarkListView(
        viewModel: viewModelcontainer.fileBookmarkListViewModel
    )
    .frame(width: 500, height: 400)
    .padding()
}
