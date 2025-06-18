//
//  FileBookmarkDeleteButtonViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 6/18/25.
//

import Foundation
import Combine

final class FileBookmarkDeleteButtonViewModel: ObservableObject, FileBookmarkSubjectBindable {
    @Published var selectedItem: FileBookmarkItem?
    var usecase: FileBookmarkUseCase
    var fileBookmarkSubject: CurrentValueSubject<FileBookmarkMessage?, Never>
    var cancellables: Set<AnyCancellable> = []
        
    init(
        usecase: FileBookmarkUseCase,
        fileBookmarkSubject: CurrentValueSubject<FileBookmarkMessage?, Never>
    ) {
        self.usecase = usecase
        self.fileBookmarkSubject = fileBookmarkSubject
        
        fileBookmarkMessageBindings()
    }
    
    func deleteItem() {
        guard let item = selectedItem else {
            print("[ERROR]: FileBookmarkDeleteButtonViewModel-deleteItem: Selected Item is nil")
            return
        }
        
        do {
            try usecase.delete(item)
        } catch {
            print("[ERROR]: FileBookmarkDeleteButtonViewModel-deleteItem: \(error)")
        }
    }
    
    
    func fileBookmarkMessageBindings() {
        fileBookmarkMessageBindings { message in
            switch message {
            case .sendSelectedItem(let item):
                self.selectedItem = item
            }
        }
    }        
}
