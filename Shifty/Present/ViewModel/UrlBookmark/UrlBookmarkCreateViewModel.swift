//
//  UrlBookmarkCreateViewModel.swift
//  Shifty
//
//  Created by 이민호 on 6/27/25.
//

import Foundation
import Combine

final class UrlBookmarkCreateViewModel: ObservableObject, ControllSubjectBindable {
    @Published var title: String = ""
    @Published var urlString: String = ""
    var controllSubject: PassthroughSubject<ControllerMessage, Never>
    var cancellables: Set<AnyCancellable> = []
    
    init(controllSubject: PassthroughSubject<ControllerMessage, Never>) {
        self.controllSubject = controllSubject
        
        /// function
        setupControllMessageBindings()
    }
    
    func buttonDisabled() -> Bool {
        return title.isEmpty || urlString.isEmpty
    }
    
    func cancel() {
        controllSubject.send(.escapePressed)
    }
    
    func reset() {
        self.title = ""
        self.urlString = ""
    }
    
    
}

// MARK: - Message Bindings
extension UrlBookmarkCreateViewModel {
    func setupControllMessageBindings() {
        controllMessageBindings{ [weak self] message in
            switch message {
            case .didHideUrlBookmarkCreateView:
                self?.reset()
            default:
                break
            }
        }
    }
}
