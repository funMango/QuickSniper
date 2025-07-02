//
//  CoreModelScrollView.swift
//  Shifty
//
//  Created by 이민호 on 6/30/25.
//

import SwiftUI
import Resolver

struct CoreModelScrollView: View {
    @Injected var viewModelContainer: ViewModelContainer
    @State var isSelected: Bool = false
    @StateObject var viewModel: CoreModelScrollViewModel
    
    init(viewModel: CoreModelScrollViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {        
        HorizontalScrollViewWithVerticalWheel {
            HStack {
                ForEach(viewModel.coreModels, id: \.id) { coreModel in
                    if let snippet = coreModel as? Snippet {
                        SnippetCardView(
                            viewModel: viewModelContainer.getSnippetCardViewModel(snippet: snippet)
                        )
                        .padding(.horizontal, 4)
                        .padding(.vertical, 4)
                    }
                    else if let fileBookmark = coreModel as? FileBookmarkItem {
                        Button {
                            
                        } label: {
                            Text(fileBookmark.name)
                        }
                        .buttonStyle(.plain)
                        .cardBackground(isSelected: $isSelected, color: .white)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 4)
                    }
                }
            }
        }
//        .overlay(
//            RoundedRectangle(cornerRadius: 10)
//                .stroke(Color.blue, lineWidth: 1)
//        )
    }
}

#Preview {
    @Injected var viewModelContainer: ViewModelContainer
    CoreModelScrollView(viewModel: viewModelContainer.coreModelScrollViewModel)
}
