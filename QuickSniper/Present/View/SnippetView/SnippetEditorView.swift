//
//  NoteEditorView.swift
//  QuickSniper
//
//  Created by 이민호 on 5/21/25.
//

import SwiftUI
import Resolver

struct SnippetEditorView: View {
    @ObservedObject var viewModel: NoteEditorViewModel
    var width: CGFloat, height: CGFloat
        
    var body: some View {
        VStack {
            // 상단 바
//            HStack {
//                Text("Snippet")
//                    .font(.title2).bold()
//                    .foregroundStyle(.mainText)
//                
//                Spacer()
//                
//                
//            }
            
            
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
            .background(VisualEffectView.panelWithOverlay)
            .padding(.bottom, 10)
            
            HStack{
                Spacer()
                
                Button {
                    viewModel.hide()
                } label: {
                    ReturnButtonStyle(type: .cancel)
                }
                .buttonStyle(.plain)
                
                Button {
                    viewModel.save()
                } label: {
                    ReturnButtonStyle(type: .save)
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
        .background(VisualEffectView.panel)
        .frame(width: width, height: height)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

#Preview {
    @Injected var viewModelContainer: ViewModelContainer
    SnippetEditorView(
        viewModel: viewModelContainer.noteEditorViewModel,
        width: 450,
        height: 600
    )
}
