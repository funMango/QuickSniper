//
//  FileBookmarkCardViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 6/18/25.
//

import Foundation
import Combine

final class FileBookmarkCardViewModel: ObservableObject, ControllSubjectBindable{
    @Published var item: FileBookmarkItem
    var controllSubject: PassthroughSubject<ControllerMessage, Never>
    var cancellables: Set<AnyCancellable> = []
    
    init(item: FileBookmarkItem, controllSubject: PassthroughSubject<ControllerMessage, Never>) {
        self.item = item
        self.controllSubject = controllSubject
    }
}
