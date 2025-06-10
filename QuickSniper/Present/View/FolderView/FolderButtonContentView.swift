//
//  RenamingButton.swift
//  QuickSniper
//
//  Created by 이민호 on 5/29/25.
//

import SwiftUI

struct FolderButtonContentView: View {
    @StateObject var viewModel: FolderButtonContentViewModel
    @FocusState private var isTextFieldFocused: Bool
    
    var isSelected: Bool
    var title: String
    
    init(
        viewModel: FolderButtonContentViewModel,
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
                Text(viewModel.folder.name)
                    .lineLimit(1)
                    .padding(.vertical, 8)
                    .foregroundColor(Color.subText)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.selectFolder()
                    }
            }
        }
    }
}

//#Preview {
//    RenameableButton(isRenaming: .constant(false))
//}
