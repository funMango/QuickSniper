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
//        CardBackground {
//            VStack(alignment: .leading, spacing: 4) {
//                content
//            }
//        }                
    }
}

#Preview {
    ItemCardView {
        
    }
    .frame(width: 400, height: 400)
}
