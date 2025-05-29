//
//  Snippet.swift
//  QuickSniper
//
//  Created by 이민호 on 5/21/25.
//

import Foundation
import SwiftData

@Model
class Snippet {
    var id: String
    var folderId: String
    var title: String
    var body: String
    var order: Int

    init(id: String = UUID().uuidString, folderId: String, title: String, body: String, order: Int) {
        self.id = id
        self.folderId = folderId
        self.title = title
        self.body = body
        self.order = order
    }
    
    func setFolderId(_ folderId: String) {
        self.folderId = folderId
    }
}
