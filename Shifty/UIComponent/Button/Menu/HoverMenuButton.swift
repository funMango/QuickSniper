//
//  CardMenuButton.swift
//  Shifty
//
//  Created by 이민호 on 6/28/25.
//

import SwiftUI

struct HoverMenuButton<Content: View>: View {
    @State var isHover = false
    private var content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
                             
    var body: some View {
        Menu {
            content
        } label: {
            ZStack {
                Circle()
                    .fill(Color.clear)
                    .frame(width: 20, height: 20)
                    .background {
                        if isHover {
                            Color.clear
                                .background(.thinMaterial)
                                .overlay(
                                    Color.white.opacity(0.4)
                                )
                        } else {
                            Color.clear
                        }
                    }
                    .clipShape(Circle())
                
                Image(systemName: "ellipsis")
            }
        }
        .labelStyle(.titleAndIcon)
        .buttonStyle(.plain)
        .onHover{ hovering in
            withAnimation {
                self.isHover = hovering
            }
        }
    }
}

#Preview {
    HoverMenuButton{
        Button {
            print("Action 1")
        } label: {
            Label("액션 1", systemImage: "star")
        }
        
        Button {
            print("Action 2")
        } label: {
            Label("액션 2", systemImage: "heart")
        }
        
        Divider()
        
        Button(role: .destructive) {
            print("삭제 액션")
        } label: {
            Label("삭제", systemImage: "trash")
        }
    }
    .frame(width: 400, height: 300)
}
