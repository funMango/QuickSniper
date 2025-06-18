//
//  FileBookmarkCardViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 6/18/25.
//

import Foundation
import Combine

final class FileBookmarkCardViewModel: ObservableObject, ControllSubjectBindable, FileBookmarkSubjectBindable {
    @Published var item: FileBookmarkItem
    @Published var isSelected: Bool = false
    var controllSubject: PassthroughSubject<ControllerMessage, Never>
    var fileBookmarkSubject: CurrentValueSubject<FileBookmarkMessage?, Never>
    var cancellables: Set<AnyCancellable> = []
    
    init(
        item: FileBookmarkItem,
        controllSubject: PassthroughSubject<ControllerMessage, Never>,
        fileBookmarkSubject: CurrentValueSubject<FileBookmarkMessage?, Never>
    ) {
        self.item = item
        self.controllSubject = controllSubject
        self.fileBookmarkSubject = fileBookmarkSubject
        
        fileBookmarkMessageBindings()        
    }
    
    func sendSelectedFileBookmarkItemMesssage() {
        fileBookmarkSubject.send(.sendSelectedItem(item))
    }
    
    func fileBookmarkMessageBindings() {
        fileBookmarkMessageBindings { [weak self] message in
            switch message {
            case .sendSelectedItem(let item):
                self?.isSelected = item.id == self?.item.id
            }
        }
    }
}
