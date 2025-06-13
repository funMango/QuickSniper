//
//  LocalShortCut.swift
//  QuickSniper
//
//  Created by 이민호 on 6/13/25.
//

import Foundation
import AppKit

struct LocalShortcut: Hashable {
    let keyCode: UInt16
    let modifiers: NSEvent.ModifierFlags
    let action: ShortcutAction
    
    enum ShortcutAction: Hashable {
        case copySnippet
        // 나중에 추가할 액션들...
    }
    
    static func create(
        keyCode: UInt16,
        modifiers: NSEvent.ModifierFlags = [],
        action: ShortcutAction) -> LocalShortcut
    {
        LocalShortcut(keyCode: keyCode, modifiers: modifiers, action: action)
    }
    
    // 이벤트와 매칭되는지 확인
    func matches(_ event: NSEvent) -> Bool {
            let eventKeyCode = event.keyCode
            let eventModifiers = event.modifierFlags
                                    
            return keyCode == eventKeyCode && modifiers.isSubset(of: eventModifiers)
        }
    
    // MARK: - Hashable 구현
    func hash(into hasher: inout Hasher) {
        hasher.combine(keyCode)
        hasher.combine(modifiers.rawValue) // rawValue로 해시
        hasher.combine(action)
    }
    
    static func == (lhs: LocalShortcut, rhs: LocalShortcut) -> Bool {
        return lhs.keyCode == rhs.keyCode &&
               lhs.modifiers == rhs.modifiers &&
               lhs.action == rhs.action
    }
}
