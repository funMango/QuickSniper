//
//  ItemSelectionRessetable.swift
//  QuickSniper
//
//  Created by 이민호 on 6/20/25.
//

import Foundation
import Combine

protocol ItemSelectionResettable: AnyObject {
    var isSelected: Bool { get set }
    var selectedFolderSubject: CurrentValueSubject<Folder?, Never> { get }
    var cancellables: Set<AnyCancellable> { get set }
}

extension ItemSelectionResettable {
    func setupItemSelectionReset() {
        selectedFolderSubject
            .sink { [weak self] _ in
                self?.isSelected = false
            }
            .store(in: &cancellables)
    }
}
