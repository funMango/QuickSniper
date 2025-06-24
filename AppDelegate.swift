//
//  AppDelegate.swift
//  Shifty
//
//  Created by 이민호 on 6/24/25.
//

import Cocoa
import Combine
import Resolver

class AppDelegate: NSObject, NSApplicationDelegate {
    @Injected var controllerContainer: ControllerContainer
            
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.delegate = self
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        controllerContainer.controllSubject.send(.openPanel)
        return true
    }
}
