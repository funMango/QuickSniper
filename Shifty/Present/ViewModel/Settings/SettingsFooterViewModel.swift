//
//  SettingsFooterViewModel.swift
//  Shifty
//
//  Created by 이민호 on 6/26/25.
//

import AppKit
import Combine

final class SettingsFooterViewModel: ObservableObject {
    func openPrivacyPolicy() {
        let url = Website.privacyPolicy.getURL()
        openWebsite(url: url)
    }
    
    func openTermsOfService() {
        let url = Website.termsOfService.getURL()
        openWebsite(url: url)
    }
    
    func openWebsite() {
        let url = Website.website.getURL()
        openWebsite(url: url)
    }
    
    private func openWebsite(url: String) {
        guard let websiteURL = URL(string: url) else {
            print("Invalid URL: \(url)")
            return
        }
        
        NSWorkspace.shared.open(websiteURL)
    }
}
