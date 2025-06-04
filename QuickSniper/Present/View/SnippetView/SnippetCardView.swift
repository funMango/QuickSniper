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
    @Binding var draggingSnippet: Snippet?
    private var isDragging: Bool {
        draggingSnippet?.id == viewModel.snippet.id
    }
    
    init(
        viewModel: SnippetCardViewModel,
        draggingSnippet: Binding<Snippet?>
    ){
        _viewModel = StateObject(wrappedValue: viewModel)
        _draggingSnippet = draggingSnippet
    }
        
    var body: some View {
        card
            .opacity(isDragging ? 0.3 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isDragging)
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
    @Injected var viewModelContainer: ViewModelContainer
    SnippetCardView(
        viewModel: viewModelContainer.getSnippetCardViewModel(
            snippet: Snippet(folderId: "", title: "", body: "", order: 1)
        ),
        draggingSnippet: .constant(nil)
    )
}
