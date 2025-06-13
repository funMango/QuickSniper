//
//  ServiceMessage.swift
//  QuickSniper
//
//  Created by 이민호 on 6/13/25.
//

import Foundation
import AppKit

enum ServiceMessage {
    case copySnippet(Snippet)
    case copySnippetBody(Snippet)
    case pressShortcut(NSEvent)
    case handleKeyEvent(NSEvent)
}
