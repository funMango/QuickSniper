//
//  LocalShortcut.swift
//  QuickSniper
//

import Foundation
import AppKit

struct LocalShortcut: Hashable {
    let keyCode: UInt16
    let modifiers: NSEvent.ModifierFlags
    let action: ShortcutAction
    
    enum ShortcutAction: Hashable {
        case copySnippet
        
        var displayName: String {
            switch self {
            case .copySnippet:
                return String(localized: "copySnippet")
            }
        }
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
    
    var name: String {
        return action.displayName
    }
    // MARK: - 단축키 표시용 프로퍼티들
            
    /// 단축키를 개별 문자열 배열로 반환 (예: ["⌘", "C"])
    var displayComponents: [String] {
        var components: [String] = []
        
        // 수식어 키들 순서대로 추가
        if modifiers.contains(.control) { components.append("⌃") }
        if modifiers.contains(.option) { components.append("⌥") }
        if modifiers.contains(.shift) { components.append("⇧") }
        if modifiers.contains(.command) { components.append("⌘") }
        
        // 메인 키 추가
        components.append(keyDisplayName)
        
        return components
    }
    
    /// 키 코드를 사람이 읽을 수 있는 문자로 변환
    private var keyDisplayName: String {
        switch keyCode {
        case 0: return "A"
        case 1: return "S"
        case 2: return "D"
        case 3: return "F"
        case 4: return "H"
        case 5: return "G"
        case 6: return "Z"
        case 7: return "X"
        case 8: return "C"
        case 9: return "V"
        case 11: return "B"
        case 12: return "Q"
        case 13: return "W"
        case 14: return "E"
        case 15: return "R"
        case 16: return "Y"
        case 17: return "T"
        case 18: return "1"
        case 19: return "2"
        case 20: return "3"
        case 21: return "4"
        case 22: return "6"
        case 23: return "5"
        case 24: return "="
        case 25: return "9"
        case 26: return "7"
        case 27: return "-"
        case 28: return "8"
        case 29: return "0"
        case 30: return "]"
        case 31: return "O"
        case 32: return "U"
        case 33: return "["
        case 34: return "I"
        case 35: return "P"
        case 36: return "↩"  // Return
        case 37: return "L"
        case 38: return "J"
        case 39: return "'"
        case 40: return "K"
        case 41: return ";"
        case 42: return "\\"
        case 43: return ","
        case 44: return "/"
        case 45: return "N"
        case 46: return "M"
        case 47: return "."
        case 48: return "⇥"  // Tab
        case 49: return "Space"
        case 51: return "⌫"  // Delete
        case 53: return "ESC"  // Escape
        case 123: return "←"
        case 124: return "→"
        case 125: return "↓"
        case 126: return "↑"
        default: return "Key\(keyCode)"
        }
    }
    
    // **MARK: - Hashable 구현**
    func hash(into hasher: inout Hasher) {
        hasher.combine(keyCode)
        hasher.combine(modifiers.rawValue)
        hasher.combine(action)
    }
    
    static func == (lhs: LocalShortcut, rhs: LocalShortcut) -> Bool {
        return lhs.keyCode == rhs.keyCode &&
               lhs.modifiers == rhs.modifiers &&
               lhs.action == rhs.action
    }
}
