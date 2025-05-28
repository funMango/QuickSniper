//
//  CreateFolderController.swift
//  QuickSniper
//
//  Created by 이민호 on 5/26/25.
//

import AppKit
import SwiftUI
import Combine
import Resolver

final class CreateFolderController {
    @Injected var viewModelContainer: ViewModelContainer
    private let subject: PassthroughSubject<ControllerMessage, Never>
    private var windowController: BaseWindowController<CreateFolderView>?
    private var cancellables = Set<AnyCancellable>()

    init(subject: PassthroughSubject<ControllerMessage, Never>) {
        self.subject = subject
        setupBindings()
    }

    func show() {                
        if windowController == nil {
            windowController = BaseWindowController(
                size: CGSize(width: 600, height: 500),
                subject: subject
            ) {
                CreateFolderView(viewModel: self.viewModelContainer.createFolderViewModel)
            }
        }
        windowController?.show()
    }
    
    private func hide() {
        windowController?.close()
        windowController = nil
        subject.send(.togglePanel)
    }
    
    private func setupBindings() {
        subject
            .sink { [weak self] message in
                if message == .hideCreateFolderView {
                    self?.hide()
                }
            }
            .store(in: &cancellables)
    }
}
