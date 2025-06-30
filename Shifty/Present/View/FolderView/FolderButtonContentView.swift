//
//  RenamingButton.swift
//  QuickSniper
//
//  Created by 이민호 on 5/29/25.
//

import SwiftUI
import Resolver

struct FolderButtonContentView: View {
    @StateObject var viewModel: FolderButtonContentViewModel
    @FocusState private var isTextFieldFocused: Bool
    var isSelected: Bool
    
    init(
        viewModel: FolderButtonContentViewModel,
        isSelected: Bool,
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.isSelected = isSelected
    }
        
    var body: some View {
        Group {
            if viewModel.isRenaming {
                TextField("", text: $viewModel.buttonText)
                    .textFieldStyle(.roundedBorder)
                    .foregroundStyle(.black)
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
                    .foregroundColor(isSelected ? .black : .primary)
                    .contentShape(Rectangle())
                    .onClick {
                        viewModel.selectFolder()
                    }                    
            }
        }
    }
}

#Preview {
    @Injected var viewModelContainer: ViewModelContainer
    let folder = Folder(name: "스니펫-1", type: .snippet, order: 0)
    
    FolderButtonContentView(
        viewModel: viewModelContainer.getFolderButtonContentViewModel(folder: folder),
        isSelected: false        
    )
    .frame(width: 300, height: 200)
}
