//
//  TypeStyleBackground.swift
//  Shifty
//
//  Created by 이민호 on 7/1/25.
//

import SwiftUI

struct TypeStyleBackground: View {
    let title: String
    let image: String
    var isSelected: Bool
    
    var body: some View {
        VStack(spacing: 18) {
            Image(systemName: image)
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                                    
            Text(title)
        }
        .frame(width: 70, height: 70)
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 0)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(isSelected ? Color.accentColor : Color.white.opacity(0.2),
                        lineWidth: isSelected ? 1 : 0.3)
        )
    }
}

#Preview {
    HStack(spacing: 15) {
        TypeStyleBackground(
            title: "File",
            image: "folder",
            isSelected: false
        )
        
        TypeStyleBackground(
            title: "Snippet",
            image: "text.page",
            isSelected: false
        )
        
        TypeStyleBackground(
            title: "URL",
            image: "link",
            isSelected: false
        )
    }
    .frame(width: 500, height: 400)
}
