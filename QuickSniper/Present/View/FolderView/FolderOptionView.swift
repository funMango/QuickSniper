//
//  FolderOptionView.swift
//  QuickSniper
//
//  Created by 이민호 on 5/27/25.
//

import SwiftUI
import Resolver

struct FolderOptionView: View {
    @Injected var viewModelContainer: ViewModelContainer
    
    var body: some View {
        VStack {
            Button {
                print("폴더 이름 수정")
            } label: {
                HStack {
                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 14) // 텍스트 높이에 맞춤
                    
                    Text(String(localized: "renameFolder"))
                }
                
            }
            
            DeleteFolderView(
                viewModel: viewModelContainer.deleteFolderViewModel
            )
        }
    }
}

#Preview {
    FolderOptionView()
}
