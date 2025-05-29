//
//  SidePanel.swift
//  QuickSniper
//
//  Created by 이민호 on 5/19/25.
//

import AppKit
import SwiftUI
import Resolver

struct PanelView: View {    
    @Injected var container: ControllerContainer
    @State private var selectedFolder: String = "Documents"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            PanelHeaderView()
                .padding(.horizontal)
                .padding(.top, 14)
                .padding(.bottom, 5)
            
            Divider()
                .padding(.horizontal)

            // 카드 스크롤 뷰
            SnippetScrollView()
        }
        .background(
            Color(.background)
        )
    }
}

#Preview {
    PanelView()
}
