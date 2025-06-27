//
//  FolderType.swift
//  QuickSniper
//
//  Created by 이민호 on 5/25/25.
//

import Foundation

enum FolderType: String, CaseIterable, Identifiable, Codable {
    static let localShortcutStorage = LocalShortcutStorage()
    case snippet = "snippet"
    case fileBookmark = "fileBookmark"
    case urlBookmark = "urlBookmark"
    
    var id: String { self.rawValue }
    
    var name: String {
        switch self {
        case .snippet:
            String(localized: "snippet")
        case .fileBookmark:
            String(localized: "fileBookmark")
        case .urlBookmark:
            String(localized: "urlBookmark")
        }
    }
    
    var relatedActions: [LocalShortcut.ShortcutAction] {
        switch self {
        case .snippet:
            return [.copySnippet]
        case .fileBookmark:
            return []
        case .urlBookmark:
            return []
        }
    }
    
    func getSymbol() -> String {
        switch self {
        case .snippet:
            return "text.page"
        case .fileBookmark:
            return "folder"
        case .urlBookmark:
            return "link"
        }
    }
    
    func getMyShortcuts() -> [LocalShortcut] {
        return Self.localShortcutStorage.shortcuts.filter { shortcut in
            relatedActions.contains(shortcut.action)
        }
    }
}
