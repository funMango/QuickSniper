//
//  ControllerMessage.swift
//  QuickSniper
//
//  Created by 이민호 on 5/26/25.
//

import Foundation

enum ControllerMessage: Equatable {
    case togglePanel
    case closePanel
    case pauseAutoHidePanel
    
    case hideCreateFolderView
    case hideSnippetEditorView
    case hideEditFolderView
    case hideShorcutSettingView
    
    case focusPanel
    
    case openShortcutSettingView
    case showShortcutSettingView
    
    case openSnippetEditorWith(Snippet)
    case openSnippetEditor    
    case showSnippetEditorWith(Snippet)
    case showSnipperEditor
}
