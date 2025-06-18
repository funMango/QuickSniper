//
//  FileBookmarkItem.swift
//  QuickSniper
//
//  Created by 이민호 on 6/15/25.
//

import Foundation
import SwiftData
import AppKit
import CoreTransferable

enum FileBookmarkType: String, Codable{
    case file = "File"
    case folder = "Folder"
}

@Model
class FileBookmarkItem: Identifiable, Codable, CoreModel {
    var id: String
    var name: String
    var type: FileBookmarkType
    var bookmarkData: Data?
    var iconData: Data?
    var order: Int?
    
    init(
        id: String = UUID().uuidString,
        name: String,
        type: FileBookmarkType,
        bookmarkData: Data? = nil,
        image: NSImage? = nil,
        order: Int? = nil
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.bookmarkData = bookmarkData
        self.order = order
        
        setIcon(image)
    }
    
    func setOrder(_ order: Int) {
        self.order = order
    }
    
    // MARK: - Codable Implementation
    enum CodingKeys: String, CodingKey {
        case id, name, type, bookmarkData, iconData, order
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        type = try container.decode(FileBookmarkType.self, forKey: .type)
        bookmarkData = try container.decodeIfPresent(Data.self, forKey: .bookmarkData)
        iconData = try container.decodeIfPresent(Data.self, forKey: .iconData)
        order = try container.decode(Int.self, forKey: .order)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(bookmarkData, forKey: .bookmarkData)
        try container.encodeIfPresent(iconData, forKey: .iconData)
        try container.encodeIfPresent(order, forKey: .order)
    }
    
    var icon: NSImage? {
        guard let iconData = iconData else { return nil }
        return NSImage(data: iconData)
    }
    
    func setIcon(_ image: NSImage?) {
        if let image = image {
            image.size = NSSize(width: 32, height: 32)
            self.iconData = image.tiffRepresentation
        } else {
            setDefaultIcon()
        }
    }
}

extension FileBookmarkItem {
    func setDefaultIcon() {
        let iconName = type == .folder ? "folder" : "doc"
        if let systemIcon = NSImage(systemSymbolName: iconName, accessibilityDescription: nil) {
            self.iconData = systemIcon.tiffRepresentation
        } else {
            print("⚠️ FileBookmarkItem - setDefaultIcon SF Symbol '\(iconName)' 로딩 실패")
        }
    }
}

extension FileBookmarkItem: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .data)
        ProxyRepresentation(exporting: \.id)
    }
}
