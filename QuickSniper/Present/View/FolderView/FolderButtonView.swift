//
//  RenamingButton.swift
//  QuickSniper
//
//  Created by 이민호 on 5/29/25.
//

import SwiftUI

struct FolderButtonView: View {
    @StateObject var viewModel: RenameableButtonViewModel
    @FocusState private var isTextFieldFocused: Bool
    
    var isSelected: Bool
    var title: String
    
    init(
        viewModel: RenameableButtonViewModel,
        isSelected: Bool,
        title: String,
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.isSelected = isSelected
        self.title = title        
    }
        
    var body: some View {
        Group {
            if viewModel.isRenaming {
                TextField("", text: $viewModel.buttonText)
                    .textFieldStyle(.roundedBorder)
                    .focused($isTextFieldFocused)
                    .frame(width: 100)
                    .onAppear {
                        DispatchQueue.main.async { isTextFieldFocused = true }
                    }
                    .onSubmit {
                        viewModel.updateFolderName()
                        viewModel.cancelRenaming()
                    }
                    .onExitCommand {
                        viewModel.updateFolderName()
                        viewModel.cancelRenaming()
                    }
            } else {
                Button(action: {
                    viewModel.selectFolder()
                }) {
                    Text(viewModel.folder.name)
                        .lineLimit(1)
                        .padding(.vertical, 8)
                        .foregroundColor(Color.subText)
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
