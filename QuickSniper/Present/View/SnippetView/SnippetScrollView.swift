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

struct SnippetScrollView: View, DraggableView {
    @Injected var container: ControllerContainer
    @Injected var viewModelContainer: ViewModelContainer
    @StateObject var viewModel: SnippetScrollViewModel
    @State var draggingItem: String?
    @Query var snippets: [Snippet]
        
    init(viewModel: SnippetScrollViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(viewModel.items, id: \.id) { snippet in
                    SnippetCardView(
                        viewModel: viewModelContainer.getSnippetCardViewModel(snippet: snippet)
                    )
                    .transition(.asymmetric(
                        insertion: .scale.combined(with: .opacity),
                        removal: .scale.combined(with: .opacity)
                    ))
                    .dragDrop(
                        viewModel: viewModel,
                        draggingItemId: $draggingItem,
                        itemId: snippet.id
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
            .animation(.easeInOut(duration: 0.3), value: viewModel.items.count)
            .frame(height: 150)
            .padding()            
            
        }
        .syncQuey(
            viewModel: self.viewModel,
            items: snippets
        )
    }
}

extension SnippetScrollView {
    func getDraggingBinding() -> Binding<String?> {
        return $draggingItem
    }
}

#Preview {
    @Injected var viewModelContainer: ViewModelContainer
    SnippetScrollView(viewModel: viewModelContainer.snippetScrollViewModel)
}
