//
//  SidePanel.swift
//  QuickSniper
//
//  Created by 이민호 on 5/19/25.
//

import AppKit
import SwiftUI
import Resolver
import SwiftData

struct PanelView: View {    
    @Injected var controllerContainer: ControllerContainer
    @Injected var viewModelContainer: ViewModelContainer
    @StateObject var viewModel: PanelViewModel
    @Query var users: [User]
    
    init(viewModel: PanelViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            PanelHeaderView(
                viewModel: viewModelContainer.panelHeaderViewModel
            )
            .padding(.horizontal)
            .padding(.top, 14)
            .padding(.bottom, 5)
            
            Divider()
                .padding(.horizontal)
            
            SnippetScrollView(
                viewModel: viewModelContainer.snippetScrollViewModel
            )
        }        
        .background(
            VisualEffectView.panel
        )
        .cornerRadius(10)
        .clipped()
        .syncQuey(viewModel: viewModel, items: users)
    }
}

//#Preview {
//    PanelView()
//}
