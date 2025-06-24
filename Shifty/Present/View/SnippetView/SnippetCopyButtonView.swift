//
//  SnippetCopyButtonView.swift
//  QuickSniper
//
//  Created by 이민호 on 6/10/25.
//

import SwiftUI

struct SnippetCopyButtonView: View {
    @StateObject var viewModel: SnippetCopyButtonViewModel
    
    init(viewModel: SnippetCopyButtonViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Button {
            viewModel.copy()
        } label: {
            OptionButtonStyle(systemName: "document.on.document", title: "copy")
        }
    }
}

//#Preview {
//    SnippetCopyButtonView()
//}
