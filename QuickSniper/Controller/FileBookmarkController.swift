//
//  FileBookmarkController.swift
//  QuickSniper
//
//  Created by 이민호 on 6/15/25.
//

import Foundation
import Combine
import Resolver

final class FileBookmarkController: ViewWindowControllable {
    @Injected var viewModelContainer: ViewModelContainer
    
    let subject: PassthroughSubject<ControllerMessage, Never>
    let hideMessage: ControllerMessage = .hideFileBookmarkCreateView
    var windowController: BasePanelController<FileBookmarkCreateView>?
    var cancellables = Set<AnyCancellable>()
    var width: CGFloat = 500, height: CGFloat = 300
    var isVisible: Bool = false
    
    init(
        subject: PassthroughSubject<ControllerMessage, Never>
    ) {
        self.subject = subject
        controllMessageBindings()
        setupBindings()
    }
    
    func makeView() -> FileBookmarkCreateView {
        return FileBookmarkCreateView()
    }
    
    func show() {
        makeWindowController(
            size: CGSize(width: width, height: height),
            page: .fileBookmark
        )
    }
            
    func controllMessageBindings() {
        subject
            .sink { [weak self] message in
                guard let self else { return }
                
                switch message {
                case .showFileBookmarkCreateView:
                    self.show()
                default: break
                }
            }
            .store(in: &cancellables)
    }
}
