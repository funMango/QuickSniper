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
    case panelStatus(Bool)
    case focusPanel
    
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
    
    // MARK: - HotCorner
    case openHotCorner
    case showHotCorner
    case hideHotCorner
    
    // MARK: - Toast
    case openToast(String)
    case showToast(String)
    
    // MARK: - FileBookmark
    case hideFileBookmarkCreateView
    case openFileBookmarkCreateView
    case showFileBookmarkCreateView
    case didHideFileBookmarkCreateView
    
    // MARK: - Page
    case stopPageAutohide
    case restartPageAutohide
    
    // MARK: - Subscription
    case openSubscriptionView
    case hideSubscriptionView
    case showSubscriptionView
        
    // MARK: - else
    case activateAutoHidePanel
    case switchPage(Page)
    case AutoHidePage(Page)
    case copySnippet
    case allPageClose
    case switchPanelWidth(CGFloat)    
}
