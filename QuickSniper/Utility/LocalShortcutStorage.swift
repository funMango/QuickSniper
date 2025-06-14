//
//  LocalShortcutStorage.swift
//  QuickSniper
//
//  Created by 이민호 on 6/14/25.
//

import Foundation

struct LocalShortcutStorage {
    var shortcuts: [LocalShortcut] = [
        LocalShortcut.create(
            keyCode: 8,
            modifiers: .command,
            action: .copySnippet
        )        
    ]
}

