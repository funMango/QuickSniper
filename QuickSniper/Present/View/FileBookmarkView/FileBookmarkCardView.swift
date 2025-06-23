//
//  FileBookmarkCardView.swift
//  QuickSniper
//
//  Created by 이민호 on 6/18/25.
//

import SwiftUI
import Resolver

struct FileBookmarkCardView: View {
    @Environment(\.openURL) private var openURL
    @StateObject var viewModel: FileBookmarkCardViewModel
    @State var draggingItemId: String?
    @State private var isDragPressed = false
    
    
    init(
        viewModel: FileBookmarkCardViewModel
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        card            
            .onClick(
                perform: {                    
                    viewModel.sendSelectedFileBookmarkItemMesssage()
                },
                onDoubleClick: {
                    viewModel.sendSelectedFileBookmarkItemMesssage()
                    viewModel.openFile()
                },
                onRightClick: {
                    viewModel.sendSelectedFileBookmarkItemMesssage()
                }
            )
            .contextMenu{
                FileBookmarkOptionMenuView()
            }                        
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
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(viewModel.isSelected ? Color.accentColor : Color.clear, lineWidth: 2)
        )
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
        type: .folder,
        order: 1
    )
    
    FileBookmarkCardView(
        viewModel: viewModelContainer.getFileBookmarkCardViewModel(item: item)
    )
}
