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
    var windowController: BasePanelController<Content>? { get set }
    var cancellables: Set<AnyCancellable> { get set }

    func makeView() -> Content
}

extension ViewWindowControllable {
    func makeWindowController(origin: CGPoint? = nil, size: CGSize, page: Page) {
        if let existing = self.windowController, existing.window != nil {
            existing.focus()
            return
        }
        
        let controller = BasePanelController(
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
                
                if message == .focusPanel {
                    self.windowController?.focus()
                }
                
                if message == self.hideMessage {
                    self.windowController?.close(isManualClose: true)
                    self.windowController = nil
                }
            }
            .store(in: &cancellables)
    }
}
