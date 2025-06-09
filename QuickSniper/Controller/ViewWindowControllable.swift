//
//  ViewWindowControllable.swift
//  QuickSniper
//
//  Created by 이민호 on 5/28/25.
//

import Foundation
import SwiftUI
import Combine

protocol ViewWindowControllable: AnyObject {
    associatedtype Content: View
    var subject: PassthroughSubject<ControllerMessage, Never> { get }
    var hideMessage: ControllerMessage { get }
    var windowController: BaseWindowController<Content>? { get set }
    var cancellables: Set<AnyCancellable> { get set }

    func makeView() -> Content
}

extension ViewWindowControllable {
    func makeWindowController(origin: CGPoint? = nil, size: CGSize, page: Page) {
        // 이미 창이 떠 있다면 show만 호출하고 리턴
        if let existing = self.windowController, let win = existing.window {
            win.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }

        // 새로 생성
        let controller = BaseWindowController(
            size: size,
            page: page,
            subject: subject
        ) {
            self.makeView()
        }
        self.windowController = controller
        controller.show()
    }

    func setupBindings() {
        subject
            .sink { [weak self] message in
                guard let self = self else { return }
                
                if message == self.hideMessage {
                    self.windowController?.close(isManualClose: true)
                    self.windowController = nil                    
                }
            }
            .store(in: &cancellables)
    }
}
