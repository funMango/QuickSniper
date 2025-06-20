//
//  FolderMessageSubjectBindable.swift
//  QuickSniper
//
//  Created by 이민호 on 6/20/25.
//

import Foundation
import Combine

protocol FolderMessageSubjectBindable: AnyObject {
    var folderMessageSubject: CurrentValueSubject<FolderMessage?, Never> { get }
    var cancellables: Set<AnyCancellable> { get set }
}

extension FolderMessageSubjectBindable {
    func folderMessageBindings(action: @escaping (FolderMessage) -> Void) {
        folderMessageSubject
            .sink { message in                
                if let message = message {
                    action(message)
                }
            }
            .store(in: &cancellables)
    }
}
