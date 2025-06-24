//
//  NoteEditorView.swift
//  QuickSniper
//
//  Created by 이민호 on 5/21/25.
//

import SwiftUI
import Resolver

enum Field: Hashable {
    case title
    case content
}

struct SnippetEditorView: View {
    @StateObject var viewModel: SnippetEditorViewModel
    @FocusState private var focusedField: Field?
    var width: CGFloat, height: CGFloat
    
    init(viewModel: SnippetEditorViewModel, width: CGFloat, height: CGFloat) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.width = width
        self.height = height
    }
        
    var body: some View {
        VStack {
            VStack {
                VStack(alignment: .leading) {
                    Spacer()
                    MultiLineTextFieldView(
                        text: $viewModel.title,
                        placeholder: String(localized: "inputTitle"),
                        type: .singleLine,
                        onTabPressed: {
                            focusedField = .content
                        }
                    )
                    .focused($focusedField, equals: .title)
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
                .focused($focusedField, equals: .content)
                .padding(.horizontal)
                
            }
            .background(VisualEffectView.panelWithOverlay)
            .padding(.bottom, 10)
            
            HStack{
                Spacer()
                
                ReturnButton(type: .cancel, action: viewModel.hide)
                
                ReturnButton(type: .save, action: viewModel.save)
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
        viewModel: viewModelContainer.snippetEditorViewModel,
        width: 450,
        height: 600
    )
}
