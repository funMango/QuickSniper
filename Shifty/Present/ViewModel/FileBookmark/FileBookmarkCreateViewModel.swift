//
//  FileBookmarkCreateViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 6/16/25.
//

import Foundation
import Combine

final class FileBookmarkCreateViewModel: ObservableObject, ControllSubjectBindable, VmPassSubjectBindable {
    
    
    var controllSubject: PassthroughSubject<ControllerMessage, Never>
    var vmPassSubject: PassthroughSubject<VmPassMessage, Never>
    var cancellables: Set<AnyCancellable> = []
    
    init(
        controllSubject: PassthroughSubject<ControllerMessage, Never>,
        vmPassSubject: PassthroughSubject<VmPassMessage, Never>
    ) {
        self.controllSubject = controllSubject
        self.vmPassSubject = vmPassSubject
    }
    
    func prev() {
        controllSubject.send(.openCreateFolderView)
    }
    
    func close() {
        controllSubject.send(.escapePressed)
    }
    
    func save() {
        vmPassSubject.send(.saveBookmarkItems)
        DispatchQueue.main.async { [weak self] in
            self?.close()
        }
    }
}
