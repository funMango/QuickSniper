//
//  FileBookmarkItem.swift
//  QuickSniper
//
//  Created by 이민호 on 6/15/25.
//

import Foundation
import SwiftData

enum FileBookmarkType: String, Codable{
    case file = "File"
    case folder = "Folder"
}

@Model
class FileBookmarkItem: Identifiable {
    var id: String
    var name: String
    var type: FileBookmarkType
    var bookmarkData: Data?
    
    init(
        id: String = UUID().uuidString,
        name: String,
        type: FileBookmarkType,
        bookmarkData: Data? = nil
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.bookmarkData = bookmarkData
    }
}
