//
//  Folder.swift
//  QuickSniper
//
//  Created by 이민호 on 5/23/25.
//

import Foundation
import SwiftData
import CoreTransferable

@Model
class Folder: Equatable, Codable, Identifiable, CoreModel {
    var id: String
    var name: String
    var type: FolderType
    var order: Int
    var folderId: String
    
    init(
        id: String = UUID().uuidString,
        name: String,
        type: FolderType,
        order: Int,
        folderId: String = ""
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.order = order
        self.folderId = folderId
    }
    
    func changeName(_ name: String) {
        self.name = name
    }
    
    func updateOrder(_ newOrder: Int) {
        self.order = newOrder
    }
    
    // MARK: - Codable Implementation
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case order
        case folderId
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        type = try container.decode(FolderType.self, forKey: .type)
        order = try container.decode(Int.self, forKey: .order)
        folderId = try container.decode(String.self, forKey: .name)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(type, forKey: .type)
        try container.encode(order, forKey: .order)
        try container.encode(folderId, forKey: .folderId)
    }
}

extension Folder: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .data)
        ProxyRepresentation(exporting: \.id)
    }
}
