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
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(FolderType.allCases, id: \.self) { type in
                        if type != .all {
                            FolderTypeCardView(
                                folderType: type,
                                isSelected: viewModel.selectedFolderType == type,
                                action: {
                                    viewModel.selectFolderType(type)
                                }
                            )
                            .padding(.vertical)
                        }
                    }
                }
                .padding(.horizontal)
            }
                                    
            HStack {
                Spacer()
                
                HStack {
                    ReturnButton(type: .cancel, action: viewModel.hide)
                    
                    ReturnButton(type: .next, action: viewModel.goNextPage)
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
