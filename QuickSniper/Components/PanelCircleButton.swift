//
//  PanelCircleButton.swift
//  QuickSniper
//
//  Created by 이민호 on 5/21/25.
//

import SwiftUI

struct PanelCircleButton: View {
    var systemName: String
    
    var body: some View {
        Image(systemName: systemName)
            .font(.headline)
            .foregroundColor(.mainText)
            .frame(width: 30, height: 30)
            .background(Color(.background))
    }
}

#Preview {
    PanelCircleButton(systemName: "plus")
}
