//
//  ToastMessage.swift
//  QuickSniper
//
//  Created by 이민호 on 6/13/25.
//

import Foundation

struct ToastMessage: Identifiable, Equatable {
    let id = UUID().uuidString
    let title: String
    let message: String?
    let type: ToastType
    let duration: TimeInterval
    
    enum ToastType {
        case success
        case info
        case warning
        case error
        
        var emoji: String {
            switch self {
            case .success: return "✅"
            case .info: return "ℹ️"
            case .warning: return "⚠️"
            case .error: return "❌"
            }
        }
    }
        
    static func create(
        title: String,
        message: String? = nil,
        duration: TimeInterval = 2.0
    ) -> ToastMessage {
        ToastMessage(title: title, message: message, type: .success, duration: duration)
    }
    
    static func copySuccess(snippetTitle: String) -> ToastMessage {
        ToastMessage(
            title: "스니펫이 복사되었습니다",
            message: snippetTitle,
            type: .success,
            duration: 1.5
        )
    }
}
