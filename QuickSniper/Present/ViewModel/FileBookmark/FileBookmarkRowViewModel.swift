//
//  FileBookmarkRowViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 6/15/25.
//

import Foundation
import Combine

final class FileBookmarkRowViewModel: ObservableObject, VmPassSubjectBindable {
    @Published var isSelected: Bool = false
    @Published var item: FileBookmarkItem
    var vmPassSubject: PassthroughSubject<VmPassMessage, Never>
    var cancellables: Set<AnyCancellable> = []
        
    init(
        item: FileBookmarkItem,
        vmPassSubject: PassthroughSubject<VmPassMessage, Never>,
    ){
        self.item = item
        self.vmPassSubject = vmPassSubject
        messageBindings()
    }
    
    func messageBindings() {
        vmPassMessageBindings { message in
            switch message{
            case .deleteCheckedBookmarkItem:
                if self.isSelected {
                    self.vmPassSubject.send(.sendCheckedBookmarkItem(self.item))
                }
            default:
                break
            }
        }
    }
}
