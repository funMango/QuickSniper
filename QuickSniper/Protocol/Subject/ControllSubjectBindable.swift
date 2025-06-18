//
//  ControllSubjectBindable.swift
//  QuickSniper
//
//  Created by 이민호 on 6/15/25.
//

import Foundation
import Combine

protocol ControllSubjectBindable: AnyObject {
    var controllSubject: PassthroughSubject<ControllerMessage, Never> { get }
    var cancellables: Set<AnyCancellable> { get set }
}

extension ControllSubjectBindable {
    func controllMessageBindings(action: @escaping (ControllerMessage) -> Void) {
        controllSubject.sink(receiveValue: action).store(in: &cancellables)
    }
}
