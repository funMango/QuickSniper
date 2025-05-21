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
    
    @FocusState private var isFocused: Bool

    var body: some View {
        ZStack(alignment: .topLeading) {
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
            .padding(.leading, -5)
            .foregroundColor(.white)
            .font(.body)
            .scrollContentBackground(.hidden)
            .focused($isFocused)
            .background(
                VisualEffectView(material: .hudWindow, blendingMode: .behindWindow)
                    .overlay(
                        Color.black.opacity(0.2) // ← 불투명도 조절 (0.0~1.0)
                    )
            )
                
                            
            if text.isEmpty && !isFocused {
                Text(placeholder)
                    .foregroundColor(.white)
                    .font(.body)
                    .allowsHitTesting(false)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)        
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
