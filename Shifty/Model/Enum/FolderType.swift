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
    
    var id: String { self.rawValue }
    
    var name: String {
        switch self {
        case .snippet:
            String(localized: "snippet")
        case .fileBookmark:
            String(localized: "fileBookmark")
        }
    }
    
    var icon: String {
        switch self {
        case .snippet:
            return "doc.text"
        case .fileBookmark:
            return "folder"
        }
    }        
    
    var relatedActions: [LocalShortcut.ShortcutAction] {
        switch self {
        case .snippet:
            return [.copySnippet]
        case .fileBookmark:
            return []
        }
    }
    
    func getSymbol() -> String {
        switch self {
        case .snippet:
            return "text.page"
        case .fileBookmark:
            return "folder"
        }
    }
    
    func getMyShortcuts() -> [LocalShortcut] {
        return Self.localShortcutStorage.shortcuts.filter { shortcut in
            relatedActions.contains(shortcut.action)
        }
    }
}
