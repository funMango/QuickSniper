//
//  CoreModelScrollViewModel.swift
//  Shifty
//
//  Created by 이민호 on 6/30/25.
//

import Foundation
import Combine

final class CoreModelScrollViewModel: ObservableObject, ControllSubjectBindable {
    @Published var panelWidth: CGFloat = 0
    var controllSubject: PassthroughSubject<ControllerMessage, Never>
    var cancellables: Set<AnyCancellable> = []
    
    init(controllSubject: PassthroughSubject<ControllerMessage, Never>) {
        self.controllSubject = controllSubject
        setupControllMessageBinding()
    }
}

extension CoreModelScrollViewModel {
    func setupControllMessageBinding() {
        controllMessageBindings{ message in
            switch message {
            case .switchPanelWidth(let width):
                self.panelWidth = width - 96
            default:
                break
            }
        }
    }
}
