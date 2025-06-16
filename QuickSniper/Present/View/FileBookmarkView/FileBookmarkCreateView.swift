//
//  FileBookmarkCreateView.swift
//  QuickSniper
//
//  Created by 이민호 on 6/15/25.
//

import SwiftUI
import Resolver

struct FileBookmarkCreateView: View {
    @Injected var viewModelContainer: ViewModelContainer
    
    var body: some View {
        VStack {
            FileBookmarkListView(
                viewModel: viewModelContainer.fileBookmarkListViewModel
            )
            
            Spacer()
            
            HStack {
                Spacer()
                ReturnButton(type: .cancel) {
                    
                }
                ReturnButton(type: .save, action: {})
            }
                        
        }
        .padding()
        .background(VisualEffectView.panelWithOverlay)
    }
}

#Preview {
    FileBookmarkCreateView()
        .frame(width: 500, height: 300)
}
