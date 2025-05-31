//
//  CancelButtonStyle.swift
//  QuickSniper
//
//  Created by 이민호 on 5/31/25.
//

import SwiftUI

enum ButtonType {
    case cancel
    case save
    
    func localized() -> String {
        switch self {
        case .cancel:
            return String(localized: "cancel")
        case .save:
            return String(localized: "save")
        }
    }
    
    func foregroundColor() -> Color {
        switch self {
        case .cancel:
            return .mainText
        case .save:
            return .white
        }
    }
    
    func backgroundColor() -> Color {
        switch self {
        case .cancel:
            return .background
        case .save:
            return .accentColor
        }
    }
}

struct ReturnButtonStyle: View {
    var type: ButtonType
        
    var body: some View {
        Text(type.localized())
            .foregroundStyle(type.foregroundColor())
            .padding(.vertical, 3)
            .padding(.horizontal, 20)
            .background(
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(type.backgroundColor())
            )
            .foregroundColor(.mainText)
    }
}

#Preview {
    ReturnButtonStyle(
        type: .cancel
    )
        .frame(width: 100, height: 100)
}
