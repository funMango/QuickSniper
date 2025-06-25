//
//  SubscriptionViewModel.swift
//  Shifty
//
//  Created by 이민호 on 6/25/25.
//

import Foundation
import Combine

final class SubscriptionViewModel: ObservableObject, ControllSubjectBindable {
    var controllSubject: PassthroughSubject<ControllerMessage, Never>
    var cancellables: Set<AnyCancellable> = []
    
    init(controllSubject: PassthroughSubject<ControllerMessage, Never>) {
        self.controllSubject = controllSubject
    }
    
    func escape() {
        controllSubject.send(.escapePressed)
    }
}
