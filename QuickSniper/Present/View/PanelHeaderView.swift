//
//  PanelHeaderView.swift
//  QuickSniper
//
//  Created by 이민호 on 5/26/25.
//

import SwiftUI
import Resolver

struct PanelHeaderView: View {
    @Injected var controllerContainer: ControllerContainer
    @Injected var viewModelContainer: ViewModelContainer
    @State private var selectedFolder: String = "Documents"
    @StateObject var viewModel: PanelHeaderViewModel
    
    init(viewModel: PanelHeaderViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
            
    var body: some View {
        HStack {
            FolderScrollView(viewModel: viewModelContainer.folderViewModel)
                                        
            HoverIconButton(
                onTap: {
                    viewModel.openCreateFolderView()
                },
                systemName: "plus"
            )
            
            Spacer()
            
            HoverIconButton(
                onTap: {
                    viewModel.closePanel()
                },
                systemName: "xmark",
                size: 14
            )
        }
        .background(
            VisualEffectView.panel
        )
    }
}

//#Preview {
//    PanelHeaderView()
//}
