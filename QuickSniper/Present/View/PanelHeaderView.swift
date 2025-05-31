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
            
    var body: some View {
        HStack {
            FolderScrollView(viewModel: viewModelContainer.folderViewModel)
                                        
            HoverIconButton(
                onTap: {
                    controllerContainer.createFolderController.show()
                },
                systemName: "plus"
            )
            
            Spacer()
            
            HoverIconButton(
                onTap: {
                    print("닫힘 버튼 눌림")
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

#Preview {
    PanelHeaderView()
}
