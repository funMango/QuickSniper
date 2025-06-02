//
//  ControllerMessage.swift
//  QuickSniper
//
//  Created by 이민호 on 5/26/25.
//

import Foundation

enum ControllerMessage: Equatable {
    case togglePanel
    case pauseAutoHidePanel
    case hideCreateFolderView
    case hideSnippetEditorView
    case hideEditFolderView    
    case focusPanel
    
    case openSnippetEditorWith(Snippet)
    case snippetEditorControllerInitWith(Snippet)
    case openSnippetEditor
    case snippetEditorControllerInit
    case showSnippetEditorWith(Snippet)
    case showSnipperEditor
}
