//
//  FileBookmarkDeleteButtonView.swift
//  QuickSniper
//
//  Created by 이민호 on 6/18/25.
//

import SwiftUI

struct FileBookmarkDeleteButtonView: View {
    @StateObject var viewModel: FileBookmarkDeleteButtonViewModel
    
    init(viewModel: FileBookmarkDeleteButtonViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Button {
            viewModel.deleteItem()
        } label: {
            OptionButtonStyle(systemName: "trash", title: "deleteBookmark")
        }
    }
}
