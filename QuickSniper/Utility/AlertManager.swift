//
//  AlertManager.swift
//  QuickSniper
//
//  Created by 이민호 on 6/18/25.
//

import AppKit

struct AlertManager {
    static func showTwoButtonAlert(
        messageText: String,
        informativeText: String,
        confirmButtonText: String,
        cancelButtonText: String = "cancel",
        onConfirm: () -> Void,
        onCancel: (() -> Void)? = nil
    ) {
        let alert = NSAlert()
        alert.messageText = NSLocalizedString(messageText, comment: "")
        alert.informativeText = NSLocalizedString(informativeText, comment: "")
        alert.alertStyle = .warning
        
        if let appIcon = NSImage(named: "AppIcon") {
            alert.icon = appIcon
        }
        
        alert.addButton(withTitle: NSLocalizedString(confirmButtonText, comment: ""))
        alert.addButton(withTitle: NSLocalizedString(cancelButtonText, comment: ""))
        
        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            onConfirm()
        } else if response == .alertSecondButtonReturn {
            onCancel?()  // 이 줄 추가!
        }
    }
    
    static func showOneButtonAlert(
        messageText: String,
        informativeText: String,
        confirmButtonText: String = "confirm",
        onConfirm: (() -> Void)? = nil
    ) {
        let alert = NSAlert()
        alert.messageText = NSLocalizedString(messageText, comment: "")
        alert.informativeText = NSLocalizedString(informativeText, comment: "")
        alert.alertStyle = .warning
        
        if let appIcon = NSImage(named: "AppIcon") {
            alert.icon = appIcon
        }
        
        alert.addButton(withTitle: NSLocalizedString(confirmButtonText, comment: ""))

        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            onConfirm?()
        }
    }
}
