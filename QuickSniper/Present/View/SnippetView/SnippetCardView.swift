//
//  SnippetCardView.swift
//  QuickSniper
//
//  Created by 이민호 on 6/1/25.
//

import SwiftUI
import Resolver

struct SnippetCardView: View {
    @StateObject var viewModel: SnippetCardViewModel
    
    init(viewModel: SnippetCardViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Button {
            viewModel.openSnippetEditor()
        } label: {
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.snippet.title)
                    .font(.title3)
                    .foregroundStyle(.mainText)
                    .padding(.bottom, 7)
                Text(viewModel.snippet.body)
                    .foregroundColor(.subText)
            }
            .padding()
            .frame(width: 240, height: 150, alignment: .topLeading)
            .background(VisualEffectView.panelWithOverlay)
            .cornerRadius(10)
        }
        .buttonStyle(.plain)
        .background(Color.clear)
    }
}

#Preview {
    @Injected var viewModelContainer: ViewModelContainer
    SnippetCardView(
        viewModel: viewModelContainer.getSnippetCardViewModel(
            snippet: Snippet(folderId: "", title: "", body: "", order: 1)
        )
    )
}
