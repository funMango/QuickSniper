//
//  SubscriptionController.swift
//  Shifty
//
//  Created by 이민호 on 6/24/25.
//

import AppKit
import SwiftUI
import Combine
import Resolver

final class SubscriptionController: ViewWindowControllable {
    @Injected var viewModelContainer: ViewModelContainer
    let subject: PassthroughSubject<ControllerMessage, Never>
    let hideMessage: ControllerMessage = .hideSubscriptionView
    var windowController: BasePanelController<SubscriptionView>?
    var cancellables = Set<AnyCancellable>()
    private var width: CGFloat = 400, height: CGFloat = 500
        
    init(subject: PassthroughSubject<ControllerMessage, Never>) {
        self.subject = subject
        setupBindings()
        controllerMessageBinding()
    }
    
    func makeView() -> SubscriptionView {
        SubscriptionView(
            viewModel: viewModelContainer.subscriptionViewModel,
            width: width,
            height: height
        )
    }
    
    func show() {
        makeWindowController(
            size: CGSize(width: width, height: height),
            page: .subscription
        )
    }
    
    func controllerMessageBinding() {
        subject.sink { [weak self] message in
            guard let self else { return }
            
            switch message {
            case .showSubscriptionView:
                show()
            default: break
            }
        }
        .store(in: &cancellables)
    }
}
