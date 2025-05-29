//
//  SnippetScrollView.swift
//  QuickSniper
//
//  Created by 이민호 on 5/29/25.
//

import SwiftUI
import Resolver

struct SnippetScrollView: View {
    @Injected var container: ControllerContainer
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack(alignment: .top, spacing: 12) {
                ForEach(SnippetStore.shared.snippets) { snippet in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(snippet.title)
                            .font(.title3)
                            .foregroundStyle(.mainText)
                            .padding(.bottom, 7)
                        Text(snippet.body)
                            .foregroundColor(.subText)
                    }
                    .padding()
                    .frame(width: 240, height: 150, alignment: .topLeading)
                    .background(.subBackground)
                }
                .padding(.trailing, 10)
                
                VStack() {
                    Spacer()
                    HoverIconButton(
                        onTap: {container.noteEditorController.show()},
                        systemName: "plus",
                        size: 30
                    )
                    Spacer()
                }
                
            }
            .frame(maxHeight: 150)
            .padding()
            .padding(.bottom)
        }
    }
}

#Preview {
    SnippetScrollView()
}
