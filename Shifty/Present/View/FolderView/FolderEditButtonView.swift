//
//  EditFolderView.swift
//  QuickSniper
//
//  Created by 이민호 on 5/28/25.
//

import SwiftUI
import Resolver

struct FolderEditButtonView: View {
    @ObservedObject var viewModel: FolderEditViewModel
    
    var body: some View {
        Button {
            viewModel.folderEdit()
        } label: {
            HStack {
                Image(systemName: "square.and.pencil")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 14)
                
                Text(String(localized: "renameFolder"))
            }
        }
    }
}
