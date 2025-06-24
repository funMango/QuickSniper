//
//  ItemScrollModifier.swift
//  QuickSniper
//
//  Created by 이민호 on 6/15/25.
//

import Foundation
import SwiftUI

// MARK: - 공통 컨테이너 스타일 ViewModifier
struct ItemScrollStyleModifier: ViewModifier {
    let itemCount: Int
    let height: CGFloat
    let spacing: CGFloat
    
    init(itemCount: Int, height: CGFloat = 150, spacing: CGFloat = 12) {
        self.itemCount = itemCount
        self.height = height
        self.spacing = spacing
    }
    
    func body(content: Content) -> some View {
        content
            .animation(.easeInOut(duration: 0.3), value: itemCount)
            .frame(height: height)
            .padding()
    }
}

// MARK: - 공통 HStack 스타일 ViewModifier
struct ItemScrollHStackModifier: ViewModifier {
    let itemCount: Int
    let spacing: CGFloat
    let height: CGFloat
    
    init(itemCount: Int, spacing: CGFloat = 12, height: CGFloat = 150) {
        self.itemCount = itemCount
        self.spacing = spacing
        self.height = height
    }
    
    func body(content: Content) -> some View {
        HStack(spacing: spacing) {
            content
        }
        .containerStyle(itemCount: itemCount, height: height, spacing: spacing)
    }
}

// MARK: - View Extension
extension View {
    func containerStyle(itemCount: Int, height: CGFloat = 150, spacing: CGFloat = 12) -> some View {
        self.modifier(ItemScrollStyleModifier(itemCount: itemCount, height: height, spacing: spacing))
    }
    
    func hStackContainer(itemCount: Int, spacing: CGFloat = 12, height: CGFloat = 150) -> some View {
        self.modifier(ItemScrollHStackModifier(itemCount: itemCount, spacing: spacing, height: height))
    }
}
