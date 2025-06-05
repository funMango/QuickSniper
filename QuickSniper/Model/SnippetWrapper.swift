//
//  SnippetWrapper.swift
//  QuickSniper
//
//  Created by 이민호 on 6/4/25.
//

//  SnippetDragSupport.swift
//  QuickSniper

import UniformTypeIdentifiers
import Foundation

// 2) Snippet → Data → Snippet 로 변환해 줄 래퍼
final class SnippetWrapper: NSObject, NSItemProviderWriting, NSItemProviderReading {
    // MARK: Model
    let snippet: Snippet
    init(snippet: Snippet) { self.snippet = snippet }

    // MARK: NSItemProviderWriting
    static var writableTypeIdentifiersForItemProvider: [String] {
        [UTType.snippet.identifier]
    }

    func loadData(withTypeIdentifier typeIdentifier: String,
                  forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        do {
            let data = try JSONEncoder().encode(snippet)
            completionHandler(data, nil)
        } catch {
            completionHandler(nil, error)
        }
        return nil
    }

    // MARK: NSItemProviderReading
    static var readableTypeIdentifiersForItemProvider: [String] {
        [UTType.snippet.identifier]
    }

    static func object(withItemProviderData data: Data,
                       typeIdentifier: String) throws -> SnippetWrapper {
        let snippet = try JSONDecoder().decode(Snippet.self, from: data)
        return SnippetWrapper(snippet: snippet)
    }
}
