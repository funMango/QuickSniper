//
//  FileBookmarkCardView.swift
//  QuickSniper
//
//  Created by 이민호 on 6/18/25.
//

import SwiftUI
import Resolver

struct FileBookmarkCardView: View {
    @StateObject var viewModel: FileBookmarkCardViewModel
    
    init(viewModel: FileBookmarkCardViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        card
    }
    
    private var card: some View {
        ItemCardView {
            VStack {
                HStack(alignment: .top) {
                    if let image = viewModel.item.icon {
                        Image(nsImage: image)
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                    
                    Text(viewModel.item.name)
                        .font(.system(size: 16))
                        .lineLimit(2)
                        .truncationMode(.tail)
                    
                    Spacer()
                }
                
                Spacer()
                
                HStack {
                    Text(viewModel.item.type.rawValue)
                        .foregroundStyle(.gray)
                    
                    Spacer()
                }
            }
        }
    }
}

extension FileBookmarkItem {
    var swiftUIIcon: Image {
        if let nsImage = icon {
            return Image(nsImage: nsImage)
        } else {
            // 기본 아이콘 반환
            let systemName = type == .folder ? "folder" : "doc"
            return Image(systemName: systemName)
        }
    }
}

#Preview {
    @Injected var viewModelContainer: ViewModelContainer
    let item = FileBookmarkItem(
        folderId: "AB$C12DO*#",
        name: "Test Item",
        type: .folder
    )
    
    FileBookmarkCardView(viewModel: viewModelContainer.getFileBookmarkCardViewModel(item: item))
}
