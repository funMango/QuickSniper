//
//  MultilineTextField.swift
//  QuickSniper
//
//  Created by 이민호 on 5/21/25.
//

import SwiftUI

enum TextFieldType {
    case multiLine
    case singleLine
}

struct MultiLineTextFieldView: View {
    @Binding var text: String
    var placeholder: String
    var type: TextFieldType
    var onTabPressed: (() -> Void)? = nil
    
    @FocusState private var isFocused: Bool

    var body: some View {
        TextEditor(text: Binding(
            get: { text },
            set: { newValue in
                if type == .singleLine {
                    text = newValue.replacingOccurrences(of: "\n", with: "")
                } else {
                    text = newValue
                }
            }
        ))
        .foregroundColor(.mainText)
        .font(.body)
        .scrollContentBackground(.hidden)
        .focused($isFocused)
        .background(Color.clear)
        .onKeyPress(.tab) {            
            onTabPressed?()
            return .handled
        }
        .overlay(alignment: .topLeading) {
            if text.isEmpty && !isFocused {
                Text(placeholder)
                    .foregroundColor(.mainText)
                    .font(.body)                    
                    .padding(.leading, 4)
                    .allowsHitTesting(false)
            }
        }
    }
}

#Preview {
    @Previewable @State var text = ""
    MultiLineTextFieldView(
        text: $text,
        placeholder: "placeholder",
        type: .singleLine
    )
}
