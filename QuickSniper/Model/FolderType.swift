//
//  FolderType.swift
//  QuickSniper
//
//  Created by 이민호 on 5/25/25.
//

import Foundation

enum FolderType: String, CaseIterable, Identifiable, Codable {
    static let localShortcutStorage = LocalShortcutStorage()
    case snippet = "Snippet"
    
    var id: String { self.rawValue }
    
    var icon: String {
        switch self {
        case .snippet:
            return "doc.text"
        }
    }
    
    var description: String {
        switch self {
        case .snippet:
            return "코드 조각이나 텍스트를 저장합니다"
        }
    }
    
    var relatedActions: [LocalShortcut.ShortcutAction] {
        switch self {
        case .snippet:
            return [.copySnippet]
        }
    }
    
    func getMyShortcuts() -> [LocalShortcut] {
        return Self.localShortcutStorage.shortcuts.filter { shortcut in
            relatedActions.contains(shortcut.action)
        }
    }
}
