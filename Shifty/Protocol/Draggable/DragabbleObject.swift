//
//  DragabbleObject.swift
//  QuickSniper
//
//  Created by 이민호 on 6/5/25.
//

import Foundation

protocol DragabbleObject: ObservableObject {
    associatedtype Item: CoreModel
    var items: [Item] { get set }
        
    func updateItems()
    func selectItem(_ itemId: String)
}

extension DragabbleObject {
    func saveChangedItems<T: CoreModel>(as type: T.Type, completion: @escaping ([T]) -> Void) {
        let changedItems = items.enumerated().compactMap { (index, item) -> T? in
            let newOrder = index + 1
            if item.order != newOrder {
                item.updateOrder(newOrder)
                return item as? T
            }
            return nil
        }
        
        guard !changedItems.isEmpty else {            
            return
        }
        
        completion(changedItems)
    }        
}
