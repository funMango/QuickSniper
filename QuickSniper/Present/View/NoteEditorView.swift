//
//  NoteEditorView.swift
//  QuickSniper
//
//  Created by 이민호 on 5/21/25.
//

import SwiftUI
import Resolver

struct NoteEditorView: View {
    @ObservedObject var viewModel: NoteEditorViewModel
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
                    viewModel.hide()
                } label: {
                    Text(String(localized: "cancel"))
                }
                
                Button {
                    viewModel.hide()
                } label: {
                    Text(String(localized: "save"))
                }
            }
            .padding(.bottom, 10)
            
            VStack {
                VStack(alignment: .leading) {
                    Spacer()
                    MultiLineTextFieldView(
                        text: $viewModel.title,
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
                    text: $viewModel.content,
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
    @Injected var viewModelContainer: ViewModelContainer
    NoteEditorView(viewModel: viewModelContainer.noteEditorViewModel)
}
