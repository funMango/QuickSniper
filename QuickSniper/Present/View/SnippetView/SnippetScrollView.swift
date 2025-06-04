//
//  SnippetScrollView.swift
//  QuickSniper
//
//  Created by 이민호 on 5/29/25.
//

import SwiftUI
import Resolver
import SwiftData
import AppKit
import UniformTypeIdentifiers

struct SnippetScrollView: View {
    @Injected var container: ControllerContainer
    @Injected var viewModelContainer: ViewModelContainer
    @StateObject var viewModel: SnippetScrollViewModel
    @State var draggingSnippet: Snippet?
    @State var isDroped = false
    @Query var snippets: [Snippet]
    
        
    init(viewModel: SnippetScrollViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            LazyHStack(alignment: .top, spacing: 12) {
                ForEach(viewModel.snippets, id: \.id) { snippet in
                    SnippetCardView(
                        viewModel: viewModelContainer.getSnippetCardViewModel(snippet: snippet),
                        draggingSnippet: $draggingSnippet
                    )
                    .onDrag {
                        draggingSnippet = snippet
                        return NSItemProvider(object: SnippetWrapper(snippet: snippet))
                    }
                    .onDrop (
                        of: [UTType.snippet],
                        delegate:EdgeDropDelegate(
                            draggingSnippet: $draggingSnippet,
                            snippets: $viewModel.snippets,
                            isDroped: $isDroped,
                            destinationSnippet: snippet
                        )
                    )
                }
                .padding(.trailing, 10)
                                                              
                VStack() {
                    Spacer()                    
                    SnippetPlusButtonView(
                        viewModel: viewModelContainer.snippetPlusButtonViewModel,
                        systemName: "plus",
                        size: 30
                    )
                    Spacer()
                }
            }
            .frame(height: 150)
            .padding()
            .padding(.bottom)
        }
        .onAppear() {
            DispatchQueue.main.async {
                viewModel.getSnippets(snippets)
            }
        }
        .onChange(of: snippets) {oldSnippets, newSnippets in
            print("snippets 변경!")
            DispatchQueue.main.async {
                viewModel.getSnippets(newSnippets)
            }
        }
        .onChange(of: isDroped) { _ , isDroped in
            DispatchQueue.main.async {
                viewModel.updateSnippets()
                self.isDroped = false
            }
        }
    }
}

#Preview {
    @Injected var viewModelContainer: ViewModelContainer
    SnippetScrollView(viewModel: viewModelContainer.snippetScrollViewModel)
}
