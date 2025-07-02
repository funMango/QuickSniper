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
    @State var isHover = false
    
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
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(viewModel.snippet.title)
                    .font(.title2)
                    .foregroundStyle(.mainText)
                    .lineLimit(1)
                    .frame(height: 20)
            
                Spacer()
                
                HoverMenuButton {
                    SnippetOptionMenuView()
                }
                .opacity(isHover ? 1.0 : 0.0)
            }
                                                                            
            Text(viewModel.snippet.body)
                .lineLimit(3)
                .foregroundColor(.gray)
            
            Spacer()
            
            HStack {
                Spacer()
                
                Image(systemName: "text.page")
                    .foregroundColor(.gray)
            }
            
        }
        .cardBackground(isSelected: $viewModel.isSelected, color: Color.block)
        .onHover { hovering in
            withAnimation {
                self.isHover = hovering
            }
        }
    }
}
    


#Preview {    
    @Injected var viewModelContainer: ViewModelContainer
    SnippetCardView(
        viewModel: viewModelContainer.getSnippetCardViewModel(
            snippet: Snippet(folderId: "dsfa", title: "dfasdfasdfasdfasdfsadasdf", body: "dasfjklsadfjlksadfasdlkdfasdfasdfsadfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfsadfsaffjsalksd", order: 1),
        )
    )
    .frame(width: 400, height: 400)
}
