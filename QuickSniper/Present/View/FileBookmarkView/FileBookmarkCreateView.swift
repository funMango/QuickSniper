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
    @StateObject var viewModel: FileBookmarkCreateViewModel
    
    init(viewModel: FileBookmarkCreateViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            FileBookmarkListView(
                viewModel: viewModelContainer.fileBookmarkListViewModel
            )
            
            Spacer()
            
            HStack {
                Spacer()
                ReturnButton(type: .cancel) {
                    viewModel.closeView()
                }
                ReturnButton(type: .save) {
                    viewModel.save()
                }
            }                        
        }
        .padding()
        .background(VisualEffectView.panelWithOverlay)
    }
}

#Preview {
    @Injected var viewModelContainer: ViewModelContainer
    
    FileBookmarkCreateView(
        viewModel: viewModelContainer.fileBookmarkCreateViewModel
    )
    .frame(width: 500, height: 300)
}
