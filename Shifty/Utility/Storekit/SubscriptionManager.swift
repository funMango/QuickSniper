//
//  SubscriptionManager.swift
//  Shifty
//
//  Created by 이민호 on 6/24/25.
//

import Foundation
import StoreKit
import Combine

@MainActor
class SubscriptionManager: ObservableObject {
    // 구독 상태 (UI에서 관찰)
    @Published var isPro = false
    
    // 상품 정보
    @Published var products: [Product] = []
    
    // 로딩 상태
    @Published var isLoading = false
    
    // 에러 메시지
    @Published var errorMessage: String?
    
    init() {        
        Task {
            await initializeStore()
        }
    }
    
    private func initializeStore() async {
        await loadProducts()
        await checkSubscriptionStatus()
    }
    
    // 나중에 구현할 메서드들
    func loadProducts() async {
    
    }
    
    func purchaseSubscription(_ product: Product) async {
        // TODO: 구매 처리
    }
    
    func checkSubscriptionStatus() async {
        // TODO: 구독 상태 확인
    }
}
