//
//  UrlBookmarkViewModel.swift
//  Shifty
//
//  Created by 이민호 on 6/27/25.
//

import Foundation
import SwiftData
import Combine

final class UrlBookmarkScrollViewModel: ObservableObject, QuerySyncableObject, FolderSubjectBindable {
    typealias Item = UrlBookmark
    @Published var allItems: [UrlBookmark] = []
    @Published var items: [UrlBookmark] = []
    @Published var selectedFolder: Folder?
    
    var selectedFolderSubject: CurrentValueSubject<Folder?, Never>
    var cancellables: Set<AnyCancellable> = []
    
    init(
        selectedFolderSubject: CurrentValueSubject<Folder?, Never>
    ) {
        self.selectedFolderSubject = selectedFolderSubject
        
        /// init function
        setupSelectedFolderBindings()
        setupItemsBindings()
    }
            
    func getItems(_ items: [UrlBookmark]) {
        self.allItems = items
    }
}

extension UrlBookmarkScrollViewModel {
    private func setupItemsBindings() {
        Publishers.CombineLatest($allItems, $selectedFolder)
            .map { items, folder -> [UrlBookmark] in
                guard let folder = folder else { return [] }
                return items
                    .filter { $0.folderId == folder.id }
                    .sorted { $0.order < $1.order }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newItems in
                self?.items = newItems
            }
            .store(in: &cancellables)
    }
}
