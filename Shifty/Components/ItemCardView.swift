//
//  ItemCardView.swift
//  QuickSniper
//
//  Created by 이민호 on 6/18/25.
//

import SwiftUI

struct ItemCardView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            content
        }
        .padding()
        .frame(width: 200, height: 150, alignment: .topLeading)
        .background(VisualEffectView.panelWithOverlay)
        .cornerRadius(10)
    }
}

