//
//  FolderType.swift
//  QuickSniper
//
//  Created by 이민호 on 5/25/25.
//

import Foundation

enum FolderType: String, CaseIterable, Identifiable {
    case snippet = "Snippet"
    case quickLink = "Quick Link"
    
    var id: String { self.rawValue }
    
    var icon: String {
        switch self {
        case .snippet:
            return "doc.text"
        case .quickLink:
            return ""
        }
    }
    
    var description: String {
        switch self {
        case .snippet:
            return "코드 조각이나 텍스트를 저장합니다"
        case .quickLink:
            return "빠른 연결을 저장합니다"
        }
    }
}
