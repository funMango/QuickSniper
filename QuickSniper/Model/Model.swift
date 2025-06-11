//
//  Model.swift
//  QuickSniper
//
//  Created by 이민호 on 6/10/25.
//

import Foundation

enum Window: Equatable {
    case shortcutSettings
    case hotCorner
    
    func getShowMessage() -> ControllerMessage {
        switch self {
        case .shortcutSettings:
            return .showShortcutSettingView
        case .hotCorner:
            return .showHotCorner
        }
    }
    
    func getHideMessage() -> ControllerMessage {
        switch self {
        case .shortcutSettings:
            return .hideShorcutSettingView
        case .hotCorner:
            return .hideHotCorner        
        }
    }
}
