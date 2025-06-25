//
//  StorekitConfig.swift
//  Shifty
//
//  Created by 이민호 on 6/24/25.
//

import Foundation

struct StoreKitConfig {
    static let monthlySubscriptionID = "com.shifty.pro.monthly"
    
    // 무료 사용자 폴더 제한
    static let freeFolderLimit = 3
    
    // 가격
    static let koreaPrice = "₩1,100/월"
    static let globalPrice = "$0.99/month"
    
    static func getPrice() -> String {
        let isKorean = Locale.current.language.languageCode?.identifier == "ko"
        return isKorean ? koreaPrice : globalPrice
    }
}
