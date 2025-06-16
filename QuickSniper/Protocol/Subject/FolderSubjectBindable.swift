//
//  FolderSubjectBindable.swift
//  QuickSniper
//

import Foundation
import Combine

protocol FolderSubjectBindable: AnyObject {
    var selectedFolder: Folder? { get set }
    var selectedFolderSubject: CurrentValueSubject<Folder?, Never> { get }
    var cancellables: Set<AnyCancellable> { get set }
}

extension FolderSubjectBindable {
    func setupSelectedFolderBindings() {
        selectedFolderSubject
            .sink { [weak self] folder in
                self?.selectedFolder = folder
            }
            .store(in: &cancellables)
    }
}
