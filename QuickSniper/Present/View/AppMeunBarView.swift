//
//  AppMenuBarView.swift
//  QuickSniper
//
//  Created by 이민호 on 6/6/25.
//

import SwiftUI
import AppKit
import SwiftData

enum MenuBarItemType {
    case settings
    case close
    case quit
}

struct AppMenuBarView: View {
    @State private var hoveredItem: MenuBarItemType? = nil
    @StateObject var viewModel: AppMenuBarViewModel    
    
    init(viewModel: AppMenuBarViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 2) {
            MenuBarItem(
                title: String(localized: "openShifty"),
                isHovered: hoveredItem == .close
            ) {
                viewModel.openPanel()
            }
            .onHover { isHovered in
                hoveredItem = isHovered ? .close : nil
            }
            
            MenuBarItem(
                title: String(localized: "settings"),
                isHovered: hoveredItem == .settings
            ) {
                viewModel.openShortcutSettingsView()
            }
            .onHover { isHovered in
                hoveredItem = isHovered ? .settings : nil
            }            
            
            Divider()
                .padding(.vertical, 4)
            
            MenuBarItem(
                title: String(localized: "exit"),
                isHovered: hoveredItem == .quit
            ) {
                NSApplication.shared.terminate(nil)
            }
            .onHover { isHovered in
                hoveredItem = isHovered ? .quit : nil
            }
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 4)
    }
}

struct MenuBarItem: View {
    let title: String
    let isHovered: Bool
    let action: () -> Void
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(isHovered ? .white : .primary)
                .font(.system(size: 13))
            
            Spacer()
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            Rectangle()
                .fill(isHovered ? Color.accentColor : Color.clear)
                .cornerRadius(4)
        )
        .onTapGesture {
            action()
        }
        .animation(.easeInOut(duration: 0.15), value: isHovered)
    }
}

//#Preview {
//    AppMenuBarView()
//        .frame(width: 200)
//        .background(Color(NSColor.controlBackgroundColor))
//}
