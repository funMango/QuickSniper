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
    @Injected var viewModelContainer: ViewModelContainer
    @StateObject var viewModel: SnippetCardViewModel
    
    init(viewModel: SnippetCardViewModel){
        _viewModel = StateObject(wrappedValue: viewModel)
    }
        
    var body: some View {
        card
            .onClick(
                perform: {
                    viewModel.sendSelectedSnippetMessage()
                },
                onDoubleClick: {
                    viewModel.sendSelectedSnippetMessage()
                    viewModel.openSnippetEditor()
                },
                onRightClick: {
                    viewModel.sendSelectedSnippetMessage()
                }
            )            
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
        ItemCardView {
            Text(viewModel.snippet.title)
                .font(.title3)
                .foregroundStyle(.mainText)
                .padding(.bottom, 7)
            Text(viewModel.snippet.body)
                .foregroundColor(.subText)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(viewModel.isSelected ? Color.accentColor : Color.clear, lineWidth: 2)
        )        
    }
}
    


#Preview {    
    @Injected var viewModelContainer: ViewModelContainer
    SnippetCardView(
        viewModel: viewModelContainer.getSnippetCardViewModel(
            snippet: Snippet(folderId: "", title: "", body: "", order: 1),
        )        
    )
}
