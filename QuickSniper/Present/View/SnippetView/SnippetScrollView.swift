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
    @Query var snippets: [Snippet]
        
    init(viewModel: SnippetScrollViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            LazyHStack(spacing: 12) {
                ForEach(viewModel.snippets, id: \.id) { snippet in
                    SnippetCardView(
                        viewModel: viewModelContainer.getSnippetCardViewModel(snippet: snippet)
                    )
                    .onDrag {
                        draggingSnippet = snippet
                        return NSItemProvider(object: SnippetWrapper(snippet: snippet))
                    }
                    .dropDestination(for: Snippet.self) { items, location in
                        draggingSnippet = nil
                        return false
                    } isTargeted: { status in
                        if let draggingSnippet, status, draggingSnippet.id != snippet.id {
                            DispatchQueue.main.async {
                                handleDrop(from: draggingSnippet, to: snippet)
                            }
                        }
                    }
                }
                .padding(.trailing, 10)
                
                Button {
                    viewModel.removeAllSnippets()
                } label: {
                    Text("all snippets remove")
                }
                                                              
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
            .animation(.easeInOut, value: viewModel.snippets)
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
    }
       
    private func handleDrop(from draggingSnippet: Snippet, to targetSnippet: Snippet){
        let from = viewModel.snippets.firstIndex(where: { $0.id == draggingSnippet.id })
        let to = viewModel.snippets.firstIndex(where: { $0.id == targetSnippet.id })
        
        if let from, let to {
            withAnimation(.easeInOut) {
                let sourceItem = viewModel.snippets.remove(at: from)
                viewModel.snippets.insert(sourceItem, at: to)
                viewModel.updateSnippets()
            }
        }
    }
}

#Preview {
    @Injected var viewModelContainer: ViewModelContainer
    SnippetScrollView(viewModel: viewModelContainer.snippetScrollViewModel)
}
