//
//  CoreModelScrollView.swift
//  Shifty
//
//  Created by 이민호 on 6/30/25.
//

import SwiftUI
import Resolver

struct CoreModelScrollView: View {
    @State var isSelected: Bool = false
    @StateObject var viewModel: CoreModelScrollViewModel
    
    init(viewModel: CoreModelScrollViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {        
        HorizontalScrollViewWithVerticalWheel {
            HStack {
                ForEach (0..<23) { index in
                    Button {
                        
                    } label: {
                        
                    }
                    .buttonStyle(.plain)
                    .cardBackground(isSelected: $isSelected, color: .white)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 4)
                }
            }
        }
//        .overlay(
//            RoundedRectangle(cornerRadius: 10)
//                .stroke(Color.blue, lineWidth: 1)
//        )
    }
}

#Preview {
    @Injected var viewModelContainer: ViewModelContainer
    CoreModelScrollView(viewModel: viewModelContainer.coreModelScrollViewModel)
}
