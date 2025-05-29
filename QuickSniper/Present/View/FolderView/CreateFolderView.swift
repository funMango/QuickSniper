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
                Text("폴더 이름:")
                
                Spacer()
                
                TextField("폴더 이름을 입력해주세요", text: $viewModel.folderName)
            }
            
            HStack {
                Text("폴더 종류:")
                
                Spacer()
                
                Menu {
                    ForEach(FolderType.allCases, id: \.self) { type in
                        Button {
                            viewModel.folderType = type
                        } label: {
                            Text(type.rawValue)
                        }
                    }
                } label: {
                    Text(viewModel.folderType.rawValue)
                }
            }
            
            HStack {
                Spacer()
                
                HStack {
                    Button {
                        viewModel.hide()
                    } label: {
                        Text("취소")
                    }
                    
                    Button {
                        viewModel.createFolder()
                    } label: {
                        Text("확인")
                    }
                }
            }
        }
        .padding()
        .frame(width: width, height: height)
        .background(Color.background)
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
