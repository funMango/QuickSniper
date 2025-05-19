//
//  SidePanel.swift
//  QuickSniper
//
//  Created by 이민호 on 5/19/25.
//

import SwiftUI

struct SidePanelView: View {
    var viewModel: SidePanelViewModel = SidePanelViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("QuickSniper")
                .font(.headline)
                .padding()
            Divider()
            Text("텍스트 1")
            Text("텍스트 2")
            Spacer()
        }
        .frame(width: 280)
        .padding(.top, 20)
        .background(
            VisualEffectView(material: .hudWindow, blendingMode: .behindWindow)
        )
        .cornerRadius(10)
        
    }
}

#Preview {
    SidePanelView()
}
