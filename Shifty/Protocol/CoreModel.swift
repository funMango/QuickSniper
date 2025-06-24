//
//  Draggable.swift
//  QuickSniper
//
//  Created by 이민호 on 6/5/25.
//

import Foundation
import CoreTransferable

protocol CoreModel: Equatable, Transferable, Identifiable {
    var id: String { get set }
    var order: Int { get set }
    
    func updateOrder(_ newOrder: Int)
}
