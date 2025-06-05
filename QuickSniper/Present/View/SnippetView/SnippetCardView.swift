//
//  SnippetCardView.swift
//  QuickSniper
//
//  Created by 이민호 on 6/1/25.
//

import SwiftUI
import Resolver
import UniformTypeIdentifiers

struct SnippetCardView: View {
    @StateObject var viewModel: SnippetCardViewModel
    
    init(
        viewModel: SnippetCardViewModel
    ){
        _viewModel = StateObject(wrappedValue: viewModel)
    }
        
    var body: some View {
        card
            .onTapGesture {
                viewModel.openSnippetEditor()
            }
            .onHover { hovering in
                if hovering {
                    viewModel.sendSelectedSnippet()
                }
            }
            .contextMenu{
                SnippetOptionMenuView()
            }
    }
    
    private var card: some View {
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
}
    


#Preview {
    @Previewable @Namespace var ns
    @Injected var viewModelContainer: ViewModelContainer
    SnippetCardView(
        viewModel: viewModelContainer.getSnippetCardViewModel(
            snippet: Snippet(folderId: "", title: "", body: "", order: 1),
        )        
    )
}
