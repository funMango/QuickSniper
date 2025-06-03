//
//  SnippetOptionMenuView.swift
//  QuickSniper
//
//  Created by 이민호 on 6/3/25.
//

import SwiftUI
import Resolver


struct SnippetOptionMenuView: View {
    @Injected var viewModelContainer: ViewModelContainer
    
    var body: some View {
        VStack {
            SnippetDeleteButtonView(
                viewModel: viewModelContainer.snippetDeleteButtonViewModel
            )
            
            Button {
                
            } label: {
                
            }
        }
    }
}

#Preview {
    SnippetOptionMenuView()
}
