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

enum FileBookmarkType: String, Codable, Equatable, Hashable {
    case file = "File"
    case folder = "Folder"
}

@Model
class FileBookmarkItem: Codable, Identifiable, Equatable, CoreModel, Hashable {    
    var id: String
    var folderId: String
    var name: String
    var type: FileBookmarkType
    var bookmarkData: Data?
    var iconData: Data?
    var order: Int
    
    init(
        id: String = UUID().uuidString,
        folderId: String,
        name: String,
        type: FileBookmarkType,
        bookmarkData: Data? = nil,
        image: NSImage? = nil,
        order: Int
    ) {
        self.id = id
        self.folderId = folderId
        self.name = name
        self.type = type
        self.bookmarkData = bookmarkData
        self.order = order
        
        setIcon(image)
    }
    
    func setOrder(_ order: Int) {
        self.order = order
    }
    
    func update(
        name: String,
        type: FileBookmarkType,
        bookmarkData: Data,
        image: NSImage
    ) {
        self.name = name
        self.type = type
        self.bookmarkData = bookmarkData
        setIcon(image)
    }
    
    func updateOrder(_ order: Int) {
        self.order = order
    }
    
    // MARK: - Codable Implementation
    enum CodingKeys: String, CodingKey {
        case id, folderId, name, type, bookmarkData, iconData, order
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        folderId = try container.decode(String.self, forKey: .folderId)
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
        try container.encode(order, forKey: .order)
    }
    
    var icon: NSImage? {
        guard let iconData = iconData else { return nil }
        return NSImage(data: iconData)
    }
}

// MARK: - 아이콘 설정
extension FileBookmarkItem {
    func setIcon(_ image: NSImage?) {
        guard let image = image else {
            setDefaultIcon()
            return
        }
        
        convertToPNG(image, source: "사용자 아이콘")
    }
    
    func setDefaultIcon() {
        let iconName = type == .folder ? "folder" : "doc"
        
        guard let systemIcon = NSImage(systemSymbolName: iconName, accessibilityDescription: nil) else {
            print("⚠️ FileBookmarkItem - setDefaultIcon: SF Symbol '\(iconName)' 로딩 실패")
            return
        }
        
        // 시스템 아이콘도 PNG로 변환
        convertToPNG(systemIcon, source: "기본 아이콘")
    }

    private func convertToPNG(_ image: NSImage, source: String) {
        // 이미지 크기 조정
        let targetSize = NSSize(width: 32, height: 32)
        let resizedImage = NSImage(size: targetSize)
        
        resizedImage.lockFocus()
        image.draw(in: NSRect(origin: .zero, size: targetSize))
        resizedImage.unlockFocus()
        
        // PNG 변환 시도
        guard let tiffData = resizedImage.tiffRepresentation else {
            print("⚠️ FileBookmarkItem - convertToPNG: \(source) TIFF 변환 실패")
            return
        }
        
        guard let bitmapRep = NSBitmapImageRep(data: tiffData) else {
            print("⚠️ FileBookmarkItem - convertToPNG: \(source) 비트맵 생성 실패, TIFF 사용")
            self.iconData = tiffData
            return
        }
        
        guard let pngData = bitmapRep.representation(using: .png, properties: [:]) else {
            print("⚠️ FileBookmarkItem - convertToPNG: \(source) PNG 변환 실패, TIFF 사용")
            self.iconData = tiffData
            return
        }
        
        // PNG 변환 성공
        self.iconData = pngData
    }
}

extension FileBookmarkItem: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .data)
        ProxyRepresentation(exporting: \.id)
    }
}
