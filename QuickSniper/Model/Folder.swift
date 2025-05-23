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
    var order: Int
    @Relationship var snippets: [Snippet]
    
    init(
        id: String = UUID().uuidString,
        name: String,
        order: Int,
        snippets: [Snippet] = []
    ) {
        self.id = id
        self.name = name
        self.order = order
        self.snippets = snippets
    }
}
