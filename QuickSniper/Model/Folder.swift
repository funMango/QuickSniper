//
//  Folder.swift
//  QuickSniper
//
//  Created by 이민호 on 5/23/25.
//

import Foundation
import SwiftData

@Model
final class Folder {
    var id: String
    var name: String
    var type: FolderType
    var order: Int
    
    init(
        id: String = UUID().uuidString,
        name: String,
        type: FolderType,
        order: Int
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.order = order
    }
}
