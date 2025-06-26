//
//  Website.swift
//  Shifty
//
//  Created by 이민호 on 6/26/25.
//

import Foundation

enum Website {
    case privacyPolicy
    case termsOfService
    case website
    
    func getURL() -> String {
        let languageCode = Locale.current.language.languageCode?.identifier
        if languageCode == "ko" {
            return getKoreaURL()
        } else {
            return getGolbalURL()
        }
    }
    
    private func getKoreaURL() -> String {
        switch self {
        case .privacyPolicy:
            return "https://stingy-llama-a98.notion.site/21dd45242c9b80d2b00df37b8c9ec249"
        case .termsOfService:
            return "https://stingy-llama-a98.notion.site/21dd45242c9b8008b277d7af3e43234e"
        case .website:
            return "https://stingy-llama-a98.notion.site/Shifty-21dd45242c9b809cb6c9db0b6d7a3e3a"
        }
    }
    
    private func getGolbalURL() -> String {
        switch self {
        case .privacyPolicy:
            return "https://stingy-llama-a98.notion.site/Privacy-Policy-21dd45242c9b80bcaaffdcd8ab4b1ad3"
        case .termsOfService:
            return "https://stingy-llama-a98.notion.site/Terms-of-Service-21dd45242c9b80b7a58aea938f8f8e70"
        case .website:
            return "https://stingy-llama-a98.notion.site/Shifty-21ed45242c9b80b5aae9ca38b4a43132"
        }
    }
}
