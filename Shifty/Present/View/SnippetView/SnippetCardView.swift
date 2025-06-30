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
            .contextMenu{
                SnippetOptionMenuView()                                    
            }
    }
    
    private var card: some View {
        VStack {
            HStack {
                Text(viewModel.snippet.title)
                    .font(.title3)
                    .foregroundStyle(.mainText)
                    .padding(.bottom, 7)
                Spacer()
            }
            
            HStack {
                Text(viewModel.snippet.body)
                    .foregroundColor(.subText)
                Spacer()
            }
            
            Spacer()
        }
        .cardBackground(isSelected: $viewModel.isSelected, color: Color.block)                      
    }
}
    


#Preview {    
    @Injected var viewModelContainer: ViewModelContainer
    SnippetCardView(
        viewModel: viewModelContainer.getSnippetCardViewModel(
            snippet: Snippet(folderId: "", title: "", body: "", order: 1),
        )        
    )
    .frame(width: 400, height: 400)
}
