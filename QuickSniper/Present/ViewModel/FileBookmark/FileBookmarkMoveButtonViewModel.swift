//
//  FileBookmarkMoveButtonViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 6/19/25.
//

import Foundation
import Combine

final class FileBookmarkMoveButtonViewModel: ObservableObject, QuerySyncableObject, FileBookmarkSubjectBindable, FolderMovable {
    typealias Item = Folder
    typealias MovableItem = FileBookmarkItem
    
    @Published var allItems: [Folder] = []
    @Published var items: [Folder] = []
    @Published var bookmark: FileBookmarkItem?
        
    var allItemsPublisher: AnyPublisher<[Folder], Never> {
        $allItems.eraseToAnyPublisher()
    }
    
    var selectedItemPublisher: AnyPublisher<FileBookmarkItem?, Never> {
        $bookmark.eraseToAnyPublisher()
    }
    
    var usecase: FileBookmarkUseCase
    var fileBookmarkSubject: CurrentValueSubject<FileBookmarkMessage?, Never>
    var cancellables: Set<AnyCancellable> = []
    
    init(
        usecase: FileBookmarkUseCase,
        fileBookmarkSubject: CurrentValueSubject<FileBookmarkMessage?, Never>
    ) {
        self.usecase = usecase
        self.fileBookmarkSubject = fileBookmarkSubject
        setupSelectedFileBookmarkItem()
        setupFolderFiltering()
    }
        
    func getItems(_ items: [Folder]) {
        DispatchQueue.main.async { [weak self] in
            self?.allItems = items
        }
    }
    
    func moveToFolder(_ folder: Folder) {
        guard let bookmark = bookmark else { return }
        bookmark.updateFolderId(folder.id)
        
        do {
            try usecase.updateFolder(bookmark)
            DispatchQueue.main.async { [weak self] in
                self?.fileBookmarkSubject.send(.refreshBookmarkItems)
            }
        } catch {
            print("[ERROR]: FileBookmarkMoveButtonViewModel-moveToFolder: \(error)")
        }        
    }
    
    private func setupSelectedFileBookmarkItem() {
        fileBookmarkMessageBindings { message in
            switch message {
            case .switchSelectedBookmarkItem(let item):
                self.bookmark = item
            default:
                break
            }
        }
    }
}
