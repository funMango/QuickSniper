//
//  VmPassMessage.swift
//  QuickSniper
//
//  Created by 이민호 on 6/16/25.
//

import Foundation

enum VmPassMessage {
    case deleteCheckedBookmarkItem
    case sendCheckedBookmarkItem(FileBookmarkItem)
    case saveBookmarkItems
}
