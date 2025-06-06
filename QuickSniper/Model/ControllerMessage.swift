//
//  ControllerMessage.swift
//  QuickSniper
//
//  Created by 이민호 on 5/26/25.
//

import Foundation

enum ControllerMessage: Equatable {
    // MARK: - Panel
    case togglePanel
    case openPanel
    case closePanel
    case pauseAutoHidePanel
    
    // MARK: - Hide
    case hideCreateFolderView
    case hideSnippetEditorView
    case hideEditFolderView
    case hideShorcutSettingView
    case escapePressed
            
    // MARK: - ShortcutSetting
    case openShortcutSettingView
    case showShortcutSettingView
    
    // MARK: - Snippet
    case openSnippetEditorWith(Snippet)
    case openSnippetEditor    
    case showSnippetEditorWith(Snippet)
    case showSnipperEditor
    
    // MARK: - else
    case focusPanel
}
