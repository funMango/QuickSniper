//
//  SettingsFooterView.swift
//  Shifty
//
//  Created by 이민호 on 6/26/25.
//

import SwiftUI

struct SettingsFooterView: View {
    @StateObject var viewModel = SettingsFooterViewModel()
    
    var body: some View {
        HStack {
            PanelButton(text: String(localized: "privacyPolicy")) {
                viewModel.openPrivacyPolicy()
            }
            PanelButton(text: String(localized: "termsOfService")) {
                viewModel.openTermsOfService()
            }
            
            Spacer()
            
            PanelButton(text: String(localized: "website")) {
                viewModel.openWebsite()
            }
        }
    }
}

#Preview {
    SettingsFooterView()
        .padding()
        .frame(width: 400, height: 300)
}
