//
//  SidePanel.swift
//  QuickSniper
//
//  Created by 이민호 on 5/19/25.
//

import AppKit
import SwiftUI
import Resolver

struct PanelView: View {    
    @Injected var container: ControllerContainer
    @State private var selectedFolder: String? = "Documents"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 상단 추가 버튼
            HStack {
                FolderView(
                    folders: ["Documents", "Downloads", "Pictures", "Music", "Videos"],
                    selectedFolder: $selectedFolder
                )
                
                HoverIconButton(onTap: {}, systemName: "plus")
                
                Spacer()
                
                HoverIconButton(
                    onTap: { print("닫힘 버튼 눌림") },
                    systemName: "xmark",
                    size: 14
                )
            }
            .padding(.horizontal)
            .padding(.top, 14)
            .padding(.bottom, 5)
            
            Divider()
                .padding(.horizontal)

            // 카드 스크롤 뷰
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
        .background(
            Color(.background)
        )
    }
}

#Preview {
    PanelView()
}
