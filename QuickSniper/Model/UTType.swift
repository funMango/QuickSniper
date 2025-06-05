//
//  UTType.swift
//  QuickSniper
//
//  Created by 이민호 on 6/5/25.
//

import Foundation
import UniformTypeIdentifiers

extension UTType {
    static let snippet = UTType(exportedAs: "sample.quickSniper.snippet")
    static let folder = UTType(exportedAs: "sample.quickSniper.folder")
            
    static func draggable<T: CoreModel>(for type: T.Type) -> UTType {
        switch String(describing: type) {
        case "Snippet":
            return .snippet
        case "Folder":
            return .folder
        default:
            return UTType(exportedAs: "sample.quickSniper.\(String(describing: type).lowercased())")
        }
    }
}
