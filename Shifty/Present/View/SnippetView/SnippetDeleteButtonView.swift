//
//  SnippetDeleteButtonView.swift
//  QuickSniper
//
//  Created by 이민호 on 6/3/25.
//

import SwiftUI

struct SnippetDeleteButtonView: View {
    @StateObject var viewModel: SnippetDeleteButtonViewModel
    
    init(viewModel: SnippetDeleteButtonViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Button {
            viewModel.deleteSnippet()
        } label: {            
            // Label(String(localized: "deleteSnippet"), systemImage: "trash")
            OptionButtonStyle(systemName: "trash", title: "deleteSnippet")
        }
    }
}

//#Preview {
//    SnippetDeleteButtonView()
//}
