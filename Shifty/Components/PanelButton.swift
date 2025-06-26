//
//  PanelButton.swift
//  Shifty
//
//  Created by 이민호 on 6/26/25.
//

import SwiftUI

struct PanelButton: View {
    var text: String
    var onClick: () -> Void
    
    var body: some View {
        Button {
            onClick()
        } label: {
            Text(text)
                .padding(.horizontal)
                .padding(.vertical, 3)                
                .background(VisualEffectView.panelWithOverlay)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    PanelButton(
        text: "웹사이트 방문",
        onClick: {}
    )
    .frame(width: 400, height: 400)
}
