//
//  SnippetMoveButtonView.swift
//  QuickSniper
//
//  Created by 이민호 on 6/9/25.
//

import SwiftUI
import Resolver
import SwiftData


struct SnippetMoveButtonView: View {
    @StateObject var viewModel: SnippetMoveButtonViewModel
    @Query var folders: [Folder]
    
    init(viewModel: SnippetMoveButtonViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Menu {
            ForEach(viewModel.items, id: \.id) { folder in
                Button {
                    viewModel.moveToFolder(folder)
                } label: {
                    Text("\(folder.name)")
                }
            }
        } label: {
            OptionButtonStyle(systemName: "arrowshape.turn.up.forward", title: "moveFolder")
        }
        .syncQuery(
            viewModel: viewModel,
            items: folders
        )
    }
}

//#Preview {
//    SnippetMoveButtonView()
//}
