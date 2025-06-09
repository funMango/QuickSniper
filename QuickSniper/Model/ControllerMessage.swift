//
//  ControllerMessage.swift
//  QuickSniper
//
//  Created by 이민호 on 5/26/25.
//

import Foundation

enum ControllerMessage: Equatable {
    // MARK: - Panel
    case deactivateAutoHidePanel
    case togglePanel
    case openPanel
    case showPanel    
    
    // MARK: - Hide
    case hidePanel
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
    
    // MARK: - Snippet
    case openCreateFolderView
    case showCreateFolderView
    
    
    // MARK: - else
    case activateAutoHidePanel
    case switchPage(Page)
    case AutoHidePage(Page)
}
