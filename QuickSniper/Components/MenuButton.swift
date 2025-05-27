//
//  MenuButton.swift
//  QuickSniper
//
//  Created by 이민호 on 5/27/25.
//

import SwiftUI
import AppKit

struct MenuButton: View {
    @State var isHovered = false
    @Binding var showMenu: Bool
    
    var body: some View {
        Button {
            showMenu.toggle()
        } label: {
            Rectangle()
                .fill(isHovered ? Color.gray : .clear) // 배경 색상
                .overlay( // 이미지 오버레이
                    Image(systemName: "ellipsis")
                        .foregroundStyle(isHovered ? Color.white : Color.gray)
                        .font(.system(size: 10))
                )
        }
        .buttonStyle(.plain)
        .frame(width: 20, height: 20)
        .background(isHovered ? .gray : .clear)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
        }        
    }
}

struct MenuDropdown: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            MenuItemView(icon: "doc.on.doc", title: "복제", shortcut: "⌘D")
            MenuItemView(icon: "pencil", title: "이름 바꾸기", shortcut: "⌘⌥R")
            MenuItemView(icon: "trash", title: "휴지통으로 이동", shortcut: "")
        }
        .padding(.vertical, 4)
        .background(Color.background)
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        .frame(width: 200)
    }
}

struct MenuItemView: View {
    let icon: String
    let title: String
    let shortcut: String
    @State private var isHovered = false
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
                .frame(width: 16)
            
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.primary)
            
            Spacer()
            
            if !shortcut.isEmpty {
                Text(shortcut)
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(isHovered ? Color.blue.opacity(0.1) : Color.clear)
        .onHover { hovering in
            isHovered = hovering
        }
        .onTapGesture {
            print("선택됨: \(title)")
        }
    }
}

#Preview {
    VStack {
        HStack {
            Text("Long Folder Name Test -1")
            Spacer()
            // MenuButton()
        }
        .padding()
        Spacer()
    }
    .frame(width: 400, height: 500)
}
