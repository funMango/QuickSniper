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

final class FolderCreateController: ViewWindowControllable {
    @Injected var viewModelContainer: ViewModelContainer

    let subject: PassthroughSubject<ControllerMessage, Never>
    let hideMessage: ControllerMessage = .hideCreateFolderView
    var windowController: BasePanelController<FolderCreateView>?
    var cancellables = Set<AnyCancellable>()
    private var width: CGFloat = 400, height: CGFloat = 250
                

    init(subject: PassthroughSubject<ControllerMessage, Never>) {
        self.subject = subject
        setupBindings()
        controllerMessageBinding()
    }

    func makeView() -> FolderCreateView {
        FolderCreateView(
            viewModel: viewModelContainer.createFolderViewModel,
            width: width,
            height: height
        )
    }

    func show() {
        makeWindowController(
            size: CGSize(width: width, height: height),
            page: .createFolder
        )
    }
    
    func controllerMessageBinding() {
        subject.sink { [weak self] message in
            guard let self else { return }
            
            switch message {
            case .showCreateFolderView:
                show()
            default: break
            }
        }
        .store(in: &cancellables)
    }
}
