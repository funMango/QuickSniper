//
//  FileBookmarkScrollView.swift
//  QuickSniper
//
//  Created by 이민호 on 6/15/25.
//

import SwiftUI
import Resolver

struct FileBookmarkScrollView: View {
    @Injected var viewModelContainer: ViewModelContainer
    
    var body: some View {
        Group {
            VStack {
                Spacer()
                ItemPlusButtonView(
                    viewModel: viewModelContainer.itemPlusButtonViewModel,
                    systemName: "plus",
                    size: 30
                )
                Spacer()
            }
            .padding(.leading, 10)
        }
        
    }
}

//#Preview {
//    FileBookmarkScrollView()
//}
