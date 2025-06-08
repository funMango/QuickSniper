//
//  Page.swift
//  QuickSniper
//
//  Created by 이민호 on 6/6/25.
//

import Foundation

enum Page: Equatable {
    case panel
    case snippetEditor
    case snippetEditorWith(Snippet)
    case shortcutSettings
    case createFolder
    
    
    func getShowMessage() -> ControllerMessage {
        switch self {
        case .panel:
            return .showPanel
        case .snippetEditor:
            return .showSnipperEditor
        case .snippetEditorWith(let snippet):
            return .showSnippetEditorWith(snippet)
        case .shortcutSettings:
            return .showShortcutSettingView
        case .createFolder:
            return .showCreateFolderView
        }
    }
    
    func getHideMessage() -> ControllerMessage {
        switch self {
        case .panel:
            return .hidePanel
        case .snippetEditor:
            return .hideSnippetEditorView
        case .snippetEditorWith:
            return .hideSnippetEditorView
        case .shortcutSettings:
            return .hideShorcutSettingView
        case .createFolder:
            return .hideCreateFolderView
        }
    }
}
