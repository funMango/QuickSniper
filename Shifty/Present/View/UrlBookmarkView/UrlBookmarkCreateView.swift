//
//  UrlBookmarkCreateView.swift
//  Shifty
//
//  Created by 이민호 on 6/27/25.
//

import SwiftUI
import Resolver

struct UrlBookmarkCreateView: View {
    @StateObject var viewModel: UrlBookmarkCreateViewModel
        
    init(
        viewModel: UrlBookmarkCreateViewModel
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text(String(localized: "urlBookmark"))
                    .font(.title2)
                Spacer()
            }
            .padding(.bottom, 20)
            
            NameTextField(
                title: String(localized: "name"),
                text: $viewModel.title
            )
            
            NameTextField(
                title: "URL",
                text: $viewModel.urlString
            )
                                                                        
            Spacer()
            
            HStack {
                Spacer()
                
                ReturnButton(type: .cancel) {
                    viewModel.cancel()
                }
                
                ReturnButton(type: .save) {
                    // 저장 함수
                }
                .disabled(viewModel.buttonDisabled())
            }
            
        }        
        .padding()
        .cornerRadius(10)
        .background(VisualEffectView.panel)
    }
}

#Preview {
    @Injected var viewModelContainer: ViewModelContainer
    
    UrlBookmarkCreateView(viewModel: viewModelContainer.urlBookmarkCreateViewModel)
        .frame(width: 400, height: 300)
        
}
