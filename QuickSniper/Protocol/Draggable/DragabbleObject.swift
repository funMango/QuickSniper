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
}
