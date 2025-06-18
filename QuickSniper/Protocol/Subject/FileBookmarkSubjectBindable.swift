//
//  FileBookmarkSubjectBindable.swift
//  QuickSniper
//
//  Created by 이민호 on 6/18/25.
//

import Foundation
import Combine

protocol FileBookmarkSubjectBindable: AnyObject {
    var fileBookmarkSubject: CurrentValueSubject<FileBookmarkMessage?, Never> { get }
    var cancellables: Set<AnyCancellable> { get set }
}

extension FileBookmarkSubjectBindable {
    func fileBookmarkMessageBindings(action: @escaping (FileBookmarkMessage) -> Void) {
        fileBookmarkSubject
            .compactMap { $0 }  // nil 제거
            .sink(receiveValue: action)
            .store(in: &cancellables)
    }
}
