//
//  QuickSniperApp.swift
//  QuickSniper
//
//  Created by 이민호 on 5/19/25.
//

import SwiftUI
import AppKit

@main
struct QuickSniperApp: App {
    var body: some Scene {
        WindowGroup {
            EmptyView()
                .onAppear {
                    _ = SidePanelController()
                }
        }
    }
}
