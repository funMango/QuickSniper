//
//  SnippetEditorView.swift
//  QuickSniper
//
//  Created by 이민호 on 5/21/25.
//

import SwiftUI

struct SnippetEditorView: View {
    @State var title = ""
    @State var text = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            TextField("제목", text: $title)
                .textFieldStyle(.roundedBorder)

            ZStack(alignment: .topLeading) {
                TextEditor(text: $text)
                    .padding(8) // ← 내부 패딩처럼 동작
            }
            .frame(maxHeight: .infinity)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3))
            )

            Button {
                
            } label: {
                Text("저장")
                    .frame(maxWidth: .infinity)
                    .frame(height: 30)
            }
        }
        .padding()
        .frame(width: 400, height: 500)
        
    }
}

#Preview {
    SnippetEditorView()
}
