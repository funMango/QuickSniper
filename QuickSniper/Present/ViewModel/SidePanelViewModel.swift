//
//  SidePanelViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 5/19/25.
//

import SwiftUI
import Combine

final class SidePanelViewModel: ObservableObject {
    @Published var isVisible: Bool = false
    
    private var timerCancellable: AnyCancellable?

    init() {
        startCursorMonitoring()
    }

    private func startCursorMonitoring() {
        timerCancellable = Timer
            .publish(every: 1.0 / 30.0, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                self.checkMousePosition()
            }
    }

    private func checkMousePosition() {
        guard let screen = NSScreen.main else { return }
        let location = NSEvent.mouseLocation
        let screenWidth = screen.frame.width

        DispatchQueue.main.async {
            self.isVisible = location.x >= screenWidth - 10
        }
    }
}
