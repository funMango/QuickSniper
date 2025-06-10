//
//  Model.swift
//  QuickSniper
//
//  Created by 이민호 on 6/10/25.
//

import Foundation

enum Window: Equatable {
    case shortcutSettings
    
    func getShowMessage() -> ControllerMessage {
        switch self {
        case .shortcutSettings:
            return .showShortcutSettingView
        }
    }
    
    func getHideMessage() -> ControllerMessage {
        switch self {
        case .shortcutSettings:
            return .hideShorcutSettingView
        }
    }
}
