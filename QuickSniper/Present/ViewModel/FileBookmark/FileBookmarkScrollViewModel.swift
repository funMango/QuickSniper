//
//  FileBookmarkScrollViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 6/18/25.
//

import Foundation
import SwiftData
import Combine

final class FileBookmarkScrollViewModel: ObservableObject, QuerySyncableObject, FolderSubjectBindable {
    typealias Item = FileBookmarkItem
    @Published var items: [FileBookmarkItem] = []
    @Published var allItems: [FileBookmarkItem] = []
    @Published var selectedFolder: Folder?
    
    var selectedFolderSubject: CurrentValueSubject<Folder?, Never>
    var cancellables: Set<AnyCancellable> = []
    
    init(selectedFolderSubject: CurrentValueSubject<Folder?, Never>) {
        self.selectedFolderSubject = selectedFolderSubject
        
        setupSelectedFolderBindings()
        setupItemsBinding()
    }
        
    func getItems(_ items: [FileBookmarkItem]) {
        self.allItems = items
    }
    
    private func setupItemsBinding() {
        Publishers.CombineLatest($allItems, $selectedFolder)
            .map { items, folder -> [FileBookmarkItem] in
                guard let folder = folder else { return [] }
                return items.filter { $0.folderId == folder.id }
                            .sorted { $0.order ?? 0 < $1.order ?? 0 }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newItems in
                self?.items = newItems
            }
            .store(in: &cancellables)
    }
}
