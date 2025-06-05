//
//  Snippet.swift
//  QuickSniper
//
//  Created by 이민호 on 5/21/25.
//

import Foundation
import SwiftData
import CoreTransferable
import UniformTypeIdentifiers

@Model
class Snippet: Codable, Identifiable{
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
    
    enum CodingKeys: String, CodingKey {
        case id
        case folderId
        case title
        case body
        case order
    }

    // MARK: - Decodable
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(String.self, forKey: .id)
        let folderId = try container.decode(String.self, forKey: .folderId)
        let title = try container.decode(String.self, forKey: .title)
        let body = try container.decode(String.self, forKey: .body)
        let order = try container.decode(Int.self, forKey: .order)
        self.init(id: id, folderId: folderId, title: title, body: body, order: order)
    }

    // MARK: - Encodable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(folderId, forKey: .folderId)
        try container.encode(title, forKey: .title)
        try container.encode(body, forKey: .body)
        try container.encode(order, forKey: .order)
    }
}

extension Snippet: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .data)
        ProxyRepresentation(exporting: \.id)
    }
}
