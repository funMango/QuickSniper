//
//  VmPassSubjectBindable.swift
//  QuickSniper
//
//  Created by 이민호 on 6/16/25.
//

import Foundation
import Combine

protocol VmPassSubjectBindable: AnyObject {
    var vmPassSubject: PassthroughSubject<VmPassMessage, Never> { get }
    var cancellables: Set<AnyCancellable> { get set }
}

extension VmPassSubjectBindable {
    func vmPassMessageBindings(action: @escaping (VmPassMessage) -> Void) {
        vmPassSubject.sink(receiveValue: action).store(in: &cancellables)
    }
}
