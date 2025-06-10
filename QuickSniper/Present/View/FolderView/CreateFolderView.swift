//
//  CreateFolderView.swift
//  QuickSniper
//
//  Created by 이민호 on 5/25/25.
//

import SwiftUI
import Resolver

struct CreateFolderView: View {
    @ObservedObject var viewModel: CreateFolderViewModel
    var width: CGFloat
    var height: CGFloat
            
    var body: some View {
        VStack(spacing: 20) {
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
            
//            HStack {
//                Text("폴더 종류:")
//                
//                Spacer()
//                
//                Menu {
//                    ForEach(FolderType.allCases, id: \.self) { type in
//                        Button {
//                            viewModel.folderType = type
//                        } label: {
//                            Text(type.rawValue)
//                        }
//                    }
//                } label: {
//                    Text(viewModel.folderType.rawValue)
//                }
//            }
            
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
    CreateFolderView(
        viewModel: viewModelcontainer.createFolderViewModel,
        width: 400,
        height: 250
    )
}
