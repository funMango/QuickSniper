//
//  RenamingButton.swift
//  QuickSniper
//
//  Created by 이민호 on 5/29/25.
//

import SwiftUI

struct RenameableButton: View {
    @ObservedObject var viewModel: RenameableButtonViewModel
    @FocusState private var isTextFieldFocused: Bool
    @State private var isRenaming = false
    
    var isSelected: Bool
    var title: String
    let onTap: () -> Void
    
    init(
        viewModel: RenameableButtonViewModel,
        isSelected: Bool,
        title: String,
        onTap: @escaping () -> Void
    ) {
        self.viewModel = viewModel
        self.isSelected = isSelected
        self.title = title
        self.onTap = onTap
    }
        
    var body: some View {
        Group {
            if viewModel.isRenaming {
                TextField("", text: $viewModel.buttonText) {
                    viewModel.toggleRenaming()
                }
                .textFieldStyle(.roundedBorder)
                .focused($isTextFieldFocused)
                .frame(width: 100)
                .onAppear {
                    DispatchQueue.main.async { isTextFieldFocused = true }
                }
                .onSubmit {
                    viewModel.toggleRenaming()
                }
                .onExitCommand {
                    viewModel.toggleRenaming()
                }
            } else {
                Button(action: {
                    onTap()
                }) {
                    Text(viewModel.folder.name)
                        .lineLimit(1)
                        .padding(.vertical, 8)
                        .foregroundColor(isSelected ? Color.point : Color.subText)
                        .contentShape(Rectangle()) // Text만큼만 클릭되는 현상 방지
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

//#Preview {
//    RenameableButton(isRenaming: .constant(false))
//}
