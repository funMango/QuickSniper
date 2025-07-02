//
//  CoreModelSubjectBindable.swift
//  Shifty
//
//  Created by 이민호 on 7/2/25.
//

import Foundation
import Combine

protocol CoreModelSubjectBindable: AnyObject {
    var coreModelSubject: CurrentValueSubject<CoreModelMessage?, Never> { get }
    var cancellables: Set<AnyCancellable> { get set }
}

extension CoreModelSubjectBindable {
    func coreModelMessageBindings(action: @escaping (CoreModelMessage) -> Void) {
        coreModelSubject
            .compactMap { $0 }
            .sink(receiveValue: action)
            .store(in: &cancellables)            
    }
}
