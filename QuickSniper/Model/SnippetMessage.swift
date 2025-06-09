//
//  SnippetMessage.swift
//  QuickSniper
//
//  Created by 이민호 on 6/3/25.
//

import Foundation

enum SnippetMessage {
    case snippetHovering(Snippet)
    case snippetReorder(String, String)
    case switchOrder(Snippet, Snippet)
    case switchFolder
    case saveSnippets
}
