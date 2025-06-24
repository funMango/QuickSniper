//
//  PlainButton.swift
//  QuickSniper
//
//  Created by 이민호 on 6/16/25.
//

import SwiftUI

struct PlainButton<Content: View>: View {
    let content: Content
    let action: () -> Void
    
    init(content: Content, action: @escaping () -> Void) {
        self.content = content
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            content
        }
        .buttonStyle(.borderless)
    }
}


