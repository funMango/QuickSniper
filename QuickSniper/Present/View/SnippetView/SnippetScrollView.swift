//
//  SnippetScrollView.swift
//  QuickSniper
//
//  Created by 이민호 on 5/29/25.
//

import SwiftUI
import Resolver
import SwiftData

struct SnippetScrollView: View {
    @Injected var container: ControllerContainer
    @StateObject var viewModel: SnippetScrollViewModel
    @Query var snippets: [Snippet]
    
    init(viewModel: SnippetScrollViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack(alignment: .top, spacing: 12) {                                                  
                ForEach(viewModel.snippets, id: \.id) { snippet in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(snippet.title)
                            .font(.title3)
                            .foregroundStyle(.mainText)
                            .padding(.bottom, 7)
                        Text(snippet.body)
                            .foregroundColor(.subText)
                    }
                    .padding()
                    .frame(width: 240, height: 150, alignment: .topLeading)
                    .background(VisualEffectView.panelWithOverlay)
                    .cornerRadius(10)
                        
                    
                }
                .padding(.trailing, 10)
                                                              
                VStack() {
                    Spacer()
                    HoverIconButton(
                        onTap: {container.noteEditorController.show()},
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
            DispatchQueue.main.async {
                viewModel.getSnippets(newSnippets)
            }
        }
    }
}

#Preview {
    @Injected var viewModelContainer: ViewModelContainer
    SnippetScrollView(viewModel: viewModelContainer.snippetScrollViewModel)
}
