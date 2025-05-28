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

final class CreateFolderController: ViewWindowControllable {
    @Injected var viewModelContainer: ViewModelContainer

    let subject: PassthroughSubject<ControllerMessage, Never>
    let hideMessage: ControllerMessage = .hideCreateFolderView
    var windowController: BaseWindowController<CreateFolderView>?
    var cancellables = Set<AnyCancellable>()

    init(subject: PassthroughSubject<ControllerMessage, Never>) {
        self.subject = subject
        setupBindings()
    }

    func makeView() -> CreateFolderView {
        CreateFolderView(viewModel: viewModelContainer.createFolderViewModel)
    }

    func show() {
        makeWindowController()
    }
}
