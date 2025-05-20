//
//  KeyTapDetector.swift
//  QuickSniper
//
//  Created by 이민호 on 5/20/25.
//

import Foundation
import AppKit

class KeyTapDetector {
    private var lastTapTime: TimeInterval = 0
    private let keyCode: UInt16
    private let interval: TimeInterval
    private let onDoubleTap: () -> Void

    init(keyCode: UInt16, interval: TimeInterval = 0.4, onDoubleTap: @escaping () -> Void) {
        self.keyCode = keyCode
        self.interval = interval
        self.onDoubleTap = onDoubleTap
        startMonitoring()
    }

    private func startMonitoring() {
        NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            guard let self = self else { return }

            if event.keyCode == self.keyCode {
                let now = Date().timeIntervalSince1970
                if now - self.lastTapTime < self.interval {
                    self.onDoubleTap()
                }
                self.lastTapTime = now
            }
        }
    }
}
