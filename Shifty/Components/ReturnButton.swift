//
//  ReturnButton.swift
//  QuickSniper
//
//  Created by 이민호 on 6/10/25.
//

import SwiftUI

struct ReturnButton: View {
    let type: ReturnButtonType // 기존 ReturnButtonStyle의 타입
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            ReturnButtonStyle(type: type)
        }
        .buttonStyle(.plain)
    }
}

//#Preview {
//    ReturnButton()
//}
