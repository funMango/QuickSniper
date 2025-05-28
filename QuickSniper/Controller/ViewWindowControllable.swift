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
    func makeWindowController() {
        if windowController == nil {
            windowController = BaseWindowController(
                size: CGSize(width: 600, height: 500),
                subject: subject,
                content: makeView
            )
        }
        windowController?.show()
    }

    func setupBindings() {
        subject
            .sink { [weak self] message in
                guard let self = self else { return }
                if message == self.hideMessage {
                    self.windowController?.close()
                    self.windowController = nil
                    self.subject.send(.focusPanel)
                }
            }
            .store(in: &cancellables)
    }
}
