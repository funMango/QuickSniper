//
//  SnippetPlusButtonView.swift
//  QuickSniper
//
//  Created by 이민호 on 6/2/25.
//

import SwiftUI
import Resolver

struct ItemPlusButtonView: View {
    @StateObject var viewModel: ItemPlusButtonViewModel
    @State private var isHovered = false
    private var systemName: String
    private var size: CGFloat
    
    init(
        viewModel: ItemPlusButtonViewModel,
        systemName: String,
        size: CGFloat = 16
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.systemName = systemName
        self.size = size
    }
    
    var body: some View {
        Button {
            viewModel.openItemSelectionView()
        } label: {
            Image(systemName: systemName)
                .font(.system(size: size, weight: .medium))
                .foregroundColor(Color.subText)
                .frame(width: size + 10, height: size + 10)
                .background {
                    if isHovered {
                        Circle()
                            .fill(Color.buttonHover)
                            .animation(.easeInOut(duration: 0.2), value: isHovered)
                    } else {
                        Color.clear
                    }
                }
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
        }
    }
}

#Preview {
    @Injected var viewModelContainer: ViewModelContainer
    ItemPlusButtonView(viewModel: viewModelContainer.itemPlusButtonViewModel,
                          systemName: "plus",
                          size: 20
    )
}
