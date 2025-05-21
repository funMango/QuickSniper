//
//  MultilineTextField.swift
//  QuickSniper
//
//  Created by 이민호 on 5/21/25.
//

import SwiftUI

struct MultiLineTextFieldView: View {
    @Binding var text: String
    var placeholder: String
    var focusColor: Color

    @FocusState private var isFocused: Bool

    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .padding(6)
                .background(Color.clear)
                .focused($isFocused)

            // ✅ 포커스 없고, 텍스트도 없을 때만 보여줌
            if text.isEmpty && !isFocused {
                Text(placeholder)
                    .foregroundColor(.gray)
                    .font(.body)
                    .padding(.leading, 9)
                    .padding(.top, 6.5)
                    .allowsHitTesting(false)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(NSColor.textBackgroundColor))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isFocused ? focusColor : Color.gray.opacity(0.3), lineWidth: 1)
        )
    }        
}

#Preview {
    @Previewable @State var text = ""
    MultiLineTextFieldView(text: $text, placeholder: "placeholder", focusColor: .red)
}
