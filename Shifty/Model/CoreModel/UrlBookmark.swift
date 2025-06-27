//
//  UrlBookmark.swift
//  Shifty
//
//  Created by 이민호 on 6/27/25.
//

import Foundation
import SwiftData
import CoreTransferable
import UniformTypeIdentifiers

@Model
class UrlBookmark: Codable, Identifiable, Equatable, CoreModel, Hashable, FolderMovableItem {
    var id: String
    var folderId: String
    var title: String
    var url: String
    var iconData: Data?
    var order: Int
             
    init(
        id: String = UUID().uuidString,
        folderId: String,
        title: String,
        url: String,
        iconData: Data?,
        order: Int
    ) {
        self.id = id
        self.folderId = folderId
        self.title = title
        self.url = url
        self.iconData = iconData
        self.order = order
    }
    
    func updateOrder(_ newOrder: Int) {
        self.order = newOrder
    }
    
    func updateFolderId(_ folderId: String) {
        self.folderId = folderId
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case folderId
        case title
        case url
        case iconData
        case order
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(String.self, forKey: .id)
        let folderId = try container.decode(String.self, forKey: .folderId)
        let title = try container.decode(String.self, forKey: .title)
        let url = try container.decode(String.self, forKey: .url)
        let iconData = try container.decodeIfPresent(Data.self, forKey: .iconData)
        let order = try container.decode(Int.self, forKey: .order)
        
        self.init(id: id, folderId: folderId, title: title, url: url, iconData: iconData, order: order)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(folderId, forKey: .folderId)
        try container.encode(title, forKey: .title)
        try container.encode(url, forKey: .url)
        try container.encodeIfPresent(iconData, forKey: .iconData)
        try container.encode(order, forKey: .order)
    }
}

extension UrlBookmark: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .data)
        ProxyRepresentation(exporting: \.id)
    }
}
