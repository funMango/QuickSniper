//
//  User.swift
//  QuickSniper
//
//  Created by 이민호 on 6/12/25.
//

import Foundation
import SwiftData
import CoreTransferable

@Model
class User: Equatable, Codable, Identifiable, CoreModel {
    var id: String
    var hotCornerPosition: HotCornerPosition
    var order = 0
    
    init (
        id: String = UUID().uuidString,
        hotCornerPosition: HotCornerPosition = .bottomLeft
    ) {
        self.id = id
        self.hotCornerPosition = hotCornerPosition
    }
    
    func updateHotCornerPosition(_ position: HotCornerPosition) {
        self.hotCornerPosition = position
    }
    
    func updateOrder(_ newOrder: Int) {
        
    }
    
    // MARK: - Codable Implementation
    enum CodingKeys: String, CodingKey {
        case id
        case hotCornerPosition
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        hotCornerPosition = try container.decode(HotCornerPosition.self, forKey: .hotCornerPosition)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(hotCornerPosition, forKey: .hotCornerPosition)
    }
}

extension User: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .data)
        ProxyRepresentation(exporting: \.id)
    }
}
