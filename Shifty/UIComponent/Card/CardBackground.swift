//
//  CardBackground.swift
//  Shifty
//
//  Created by 이민호 on 6/30/25.
//

import SwiftUI

struct CardBackgroundTestView: View {
    @State var isSelected = false
    var color = Color.block
    
    var body: some View {
        VStack {
            Button {
                isSelected.toggle()
            } label: {
                
            }
            .buttonStyle(.plain)
            .cardBackground(isSelected: $isSelected, color: color)
        }
        .frame(width: 400, height: 300)
    }
}

private struct CardBackgroundModifier: ViewModifier {
    @Binding var isSelected: Bool
    let color: Color

    func body(content: Content) -> some View {
        content
            .frame(width: 180, height: 100)
            .padding()
            .background {
                Color.clear
                    .background(.ultraThinMaterial)
                    .overlay(
                        color.opacity(0.1)
                    )
            }
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .stroke(Color.white.opacity(0.2), lineWidth: 0.3)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 2)
            )
    }
}

extension View {
    func cardBackground(isSelected: Binding<Bool>, color: Color) -> some View {
        self.modifier(CardBackgroundModifier(isSelected: isSelected, color: color))
    }
}

#Preview {
    CardBackgroundTestView()
}
