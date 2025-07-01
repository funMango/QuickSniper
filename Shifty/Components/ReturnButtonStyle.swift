//
//  CancelButtonStyle.swift
//  QuickSniper
//
//  Created by 이민호 on 5/31/25.
//

import SwiftUI

enum ReturnButtonType {
    case cancel
    case save
    case next
    
    func localized() -> String {
        switch self {
        case .cancel:
            return String(localized: "cancel")
        case .save:
            return String(localized: "save")
        case .next:
            return String(localized: "next")
        }
    }
    
    func foregroundColor() -> Color {
        switch self {
        case .cancel:
            return .mainText
        case .save:
            return .white
        case .next:
            return .white
        }
    }
    
    func backgroundColor() -> Color {
        switch self {
        case .cancel:
            return .background
        case .save:
            return .accentColor
        case .next:
            return .accentColor
        }
    }
}

struct ReturnButtonStyle: View {
    var type: ReturnButtonType
        
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
