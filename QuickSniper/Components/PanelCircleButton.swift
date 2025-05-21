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
            .foregroundColor(.primary)
            .frame(width: 30, height: 30)
            .background(.regularMaterial)
            .clipShape(Circle())
    }
}
