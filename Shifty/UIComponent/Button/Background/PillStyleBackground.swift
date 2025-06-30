//
//  PillStyleBackground.swift
//  Shifty
//
//  Created by 이민호 on 6/30/25.
//

import SwiftUI

struct PillButtonStyleExample: View {
    @State var isSelected: Bool = false
    var color = Color.block
    
    var body: some View {
        Button {
            isSelected.toggle()
        } label: {
            HStack {
                Text("button")
                    .foregroundStyle(isSelected ? .black : .primary)
            }
        }
        .buttonStyle(.plain)
        .pillStyleBackground(isSelected: $isSelected, color: color)
    }
}

private struct PillStyleBackgroundModifier: ViewModifier {
    @Binding var isSelected: Bool
    var color: Color

    func body(content: Content) -> some View {
        content // 이 부분이 HStack의 내용을 의미합니다.
            .padding(.horizontal)
            .frame(height: 30)
            .frame(minWidth: 80)
            .background {
                if isSelected {
                    Color.white
                }
                else {
                    Color.clear
                        .background(.ultraThinMaterial)
                        .overlay(
                            color.opacity(0.1)
                        )
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.white.opacity(0.2), lineWidth: 0.3)
            )
    }
}

extension View {
    func pillStyleBackground(isSelected: Binding<Bool>, color: Color) -> some View {
        self.modifier(PillStyleBackgroundModifier(isSelected: isSelected, color: color))
    }
}


#Preview {
    PillButtonStyleExample()
        .frame(width: 400, height: 400)
}

