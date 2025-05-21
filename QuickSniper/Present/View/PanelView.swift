//
//  SidePanel.swift
//  QuickSniper
//
//  Created by 이민호 on 5/19/25.
//

import AppKit
import SwiftUI

struct PanelView: View {    
    private let controller = NoteEditorWindowController()

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 상단 추가 버튼
            HStack {
                Button(action: {
                    print("닫힘 버튼 눌림")
                }) {
                    PanelCircleButton(systemName: "xmark")
                }
                .buttonStyle(PlainButtonStyle())
                
                
                Button(action: {
                    controller.show()
                }) {
                    PanelCircleButton(systemName: "plus")
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal)
            .padding(.top, 14)

            // 카드 스크롤 뷰
            ScrollView(.horizontal, showsIndicators: true) {
                HStack(alignment: .top, spacing: 12) {
                    ForEach(SnippetStore.shared.snippets) { snippet in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(snippet.title)
                                .font(.headline)
                            Text(snippet.body)
                                .font(.caption)
                                .foregroundColor(.gray)
                                .lineLimit(5)
                        }
                        .padding()
                        .frame(width: 240, alignment: .topLeading) // 높이 생략
                        .background(.regularMaterial)
                        .cornerRadius(8)
                    }
                }
                .padding()
                .padding(.bottom)
            }
        }
        .background(
            VisualEffectView(material: .hudWindow, blendingMode: .behindWindow)
        )       
    }
}

extension PanelView {
    func showNoteEditorWindow() {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 600, height: 700),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered, defer: false)
        window.center()
        window.contentView = NSHostingView(rootView: NoteEditorView())
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}

#Preview {
    PanelView()
}
