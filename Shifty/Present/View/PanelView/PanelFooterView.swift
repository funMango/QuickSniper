//
//  PanelFooterView.swift
//  QuickSniper
//
//  Created by 이민호 on 6/14/25.
//

import SwiftUI
import Combine

struct PanelFooterView: View {
    @StateObject var viewModel: PanelFooterViewModel
    
    init(viewModel: PanelFooterViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // 단축키들
            shortcutsContent
            
            Spacer()
        }
        .padding(.bottom, 8)
        .padding(.horizontal)
        .frame(height: 20)
    }
    
    // MARK: - Subviews
    
    private var shortcutsContent: some View {
        HStack(spacing: 10) {
            ForEach(viewModel.localShortcuts, id: \.self) { shortcut in
                shortcutRow(shortcut)
            }
        }
    }
    
    private func shortcutRow(_ shortcut: LocalShortcut) -> some View {
        HStack(spacing: 5) {
            // 액션 이름
            Text(shortcut.name)
                .font(.caption)
                .foregroundColor(.gray)
            
            // 단축키 키들
            HStack(spacing: 0) {
                ForEach(shortcut.displayComponents, id: \.self) { key in
                    Text(key)
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
            }
        }
        .background(.clear)
    }
}


// MARK: - Preview
#Preview {
    let mockShortcut = LocalShortcut.create(
        keyCode: 8,
        modifiers: .command,
        action: .copySnippet
    )
    
    let mockViewModel = PanelFooterViewModel(
        selectedFolderSubject: CurrentValueSubject<Folder?, Never>(nil)
    )
    mockViewModel.localShortcuts = [mockShortcut]
    
    return PanelFooterView(viewModel: mockViewModel)
        .frame(width: 400, height: 60)
        .background(Color.black.opacity(0.1))
}
