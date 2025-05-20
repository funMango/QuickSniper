//
//  SettingView.swift
//  QuickSniper
//
//  Created by 이민호 on 5/20/25.
//

import SwiftUI
import KeyboardShortcuts

struct SettingsView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("단축키 설정")
                .font(.headline)

            KeyboardShortcuts.Recorder("패널 토글", name: .toggleQuickSniper)
        }
        .padding()
        .frame(width: 250)
    }
}

#Preview {
    SettingsView()
}
