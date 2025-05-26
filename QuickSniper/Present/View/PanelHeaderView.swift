//
//  PanelHeaderView.swift
//  QuickSniper
//
//  Created by 이민호 on 5/26/25.
//

import SwiftUI
import Resolver

struct PanelHeaderView: View {
    @State private var selectedFolder: String = "Documents"
    @Injected var controllerContainer: ControllerContainer
    
    
    var body: some View {
        HStack {
            FolderView()
                                        
            HoverIconButton(
                onTap: {
                    controllerContainer.createFolderController.show()
                },
                systemName: "plus"
            )
            
            Spacer()
            
            HoverIconButton(
                onTap: { print("닫힘 버튼 눌림") },
                systemName: "xmark",
                size: 14
            )
        }
        .background(Color.background)
    }
}

#Preview {
    PanelHeaderView()
}
