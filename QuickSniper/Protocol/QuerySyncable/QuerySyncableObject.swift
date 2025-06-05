//
//  QuerySyncableObject.swift
//  QuickSniper
//
//  Created by 이민호 on 6/5/25.
//

import Foundation

protocol QuerySyncableObject: ObservableObject {
    associatedtype Item: CoreModel    
    var allItems: [Item] { get set }
    
    func getItems(_ items: [Item])
}
