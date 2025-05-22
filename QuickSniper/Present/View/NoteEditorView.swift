//
//  NoteEditorView.swift
//  QuickSniper
//
//  Created by 이민호 on 5/21/25.
//

import SwiftUI

struct NoteEditorView: View {
    @State private var title: String = ""
    @State private var bodyText: String = ""

    var body: some View {
        VStack {
            // 상단 바
            HStack {
                Text("Snippet")
                    .font(.title2).bold()
                    .foregroundStyle(.white)
                
                Spacer()
                
                Button {
                    
                } label: {
                    Text(String(localized: "save"))
                }
            }
            .padding(.bottom, 10)
            
            VStack {
                VStack(alignment: .leading) {
                    Spacer()
                    MultiLineTextFieldView(
                        text: $title,
                        placeholder: String(localized: "inputTitle"),
                        type: .singleLine
                    )
                    .padding(.bottom, 7)
                    Divider()
                    Spacer()
                }
                .frame(height: 50)
                .padding(.top)
                .padding(.horizontal)
                                                                    
                MultiLineTextFieldView(
                    text: $bodyText,
                    placeholder: String(localized: "inputContent"),
                    type: .multiLine
                )
                .padding(.horizontal)
                
            }
            .background(
                VisualEffectView(material: .hudWindow, blendingMode: .behindWindow)
                        .cornerRadius(20)
                        .overlay(
                            Color.black.opacity(0.2) // ← 불투명도 조절 (0.0~1.0)
                                .cornerRadius(10)
                        )                    
            )
        }
        .padding()
        .background(
            VisualEffectView(material: .hudWindow, blendingMode: .behindWindow)
        )
        .frame(width: 600, height: 700)
    }
}

#Preview {
    NoteEditorView()
}
