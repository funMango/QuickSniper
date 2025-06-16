//
//  CreateFolderView.swift
//  QuickSniper
//
//  Created by 이민호 on 5/25/25.
//

import SwiftUI
import Resolver

struct FolderCreateView: View {
    @ObservedObject var viewModel: FolderCreateViewModel
    var width: CGFloat
    var height: CGFloat
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 3)
            
    var body: some View {
        VStack(spacing: 20) {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(FolderType.allCases, id: \.self) { type in
                        FolderTypeCardView(
                            folderType: type,
                            isSelected: viewModel.selectedFolderType == type,
                            action: {
                                viewModel.selectFolderType(type)
                            }
                        )
                        .padding(.vertical, 3)
                        .padding(.horizontal, 5)
                    }
                }
            }
                        
            HStack {
                Text(String(localized: "folderName"))
                
                Spacer()
                
                TextField(String(localized: "enterFolderName"), text: $viewModel.folderName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: viewModel.folderName) { oldValue, newValue in
                        if newValue.count > 20 {
                            viewModel.folderName = String(newValue.prefix(20))
                        }
                    }
            }
            
            HStack {
                Spacer()
                
                HStack {
                    ReturnButton(type: .cancel, action: viewModel.hide)
                    
                    ReturnButton(type: .save, action: viewModel.createFolder)                                        
                }
            }
        }
        .padding()
        .background(VisualEffectView.panel)
        .cornerRadius(10)
        .frame(width: width, height: height)
    }
}
#Preview {
    @Injected var viewModelcontainer: ViewModelContainer
    FolderCreateView(
        viewModel: viewModelcontainer.createFolderViewModel,
        width: 400,
        height: 300
    )
}
