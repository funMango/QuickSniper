//
//  UrlBookmarkCreateController.swift
//  Shifty
//
//  Created by 이민호 on 6/27/25.
//

import Foundation
import Combine
import Resolver

final class UrlBookmarkController: ViewWindowControllable {
    @Injected var viewModelContainer: ViewModelContainer
    
    var subject: PassthroughSubject<ControllerMessage, Never>
    var hideMessage: ControllerMessage = .hideUrlBookmarkCreateView
    var windowController: BasePanelController<UrlBookmarkCreateView>?
    var cancellables: Set<AnyCancellable> = []
    var width: CGFloat = 400, height: CGFloat = 300
    
    init(
        subject: PassthroughSubject<ControllerMessage, Never>
    ) {
        self.subject = subject
        controllMessageBindings()
        setupBindings()
    }
    
    func makeView() -> UrlBookmarkCreateView {
        return UrlBookmarkCreateView(
            viewModel: viewModelContainer.urlBookmarkCreateViewModel
        )
    }
    
    func show() {
        makeWindowController(
            size: CGSize(width: width, height: height),
            page: .urlBookmark
        )
    }
    
    func controllMessageBindings() {
        subject
            .sink { [weak self] message in
                guard let self else { return }
                
                switch message {
                case .showUrlBookmarkCreateView:
                    self.show()
                default: break
                }
            }
            .store(in: &cancellables)
    }
}
