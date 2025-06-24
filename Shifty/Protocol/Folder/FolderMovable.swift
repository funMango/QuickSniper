//
//  FolderMovable.swift
//  QuickSniper
//
//  Created by 이민호 on 6/19/25.
//

import Foundation
import Combine

// 폴더 이동 가능한 아이템의 프로토콜
protocol FolderMovableItem {
    var folderId: String { get }
}

// 폴더 이동 기능을 제공하는 ViewModel 프로토콜
protocol FolderMovable: ObservableObject {
    associatedtype MovableItem: FolderMovableItem
    
    var allItems: [Folder] { get set }
    var items: [Folder] { get set }
    var cancellables: Set<AnyCancellable> { get set }
    
    // allItems의 Publisher도 제공
    var allItemsPublisher: AnyPublisher<[Folder], Never> { get }
    // 현재 선택된 아이템을 반환하는 Publisher
    var selectedItemPublisher: AnyPublisher<MovableItem?, Never> { get }
}

extension FolderMovable {
    // 공통 로직을 extension으로 제공
    func setupFolderFiltering() {
        Publishers.CombineLatest(allItemsPublisher, selectedItemPublisher)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] allFolders, selectedItem in
                guard let selectedItem = selectedItem else {
                    self?.items = []
                    return
                }
                
                let targetFolder = allFolders.first { $0.id == selectedItem.folderId }
                self?.items = allFolders
                    .filter { $0.id != selectedItem.folderId }  // 현재 폴더 제외
                    .filter { $0.type == targetFolder?.type }   // 같은 타입만
                    .sorted { $0.order < $1.order }             // 순서대로 정렬
            }
            .store(in: &self.cancellables)
    }
}
