//
//  RepositoryRegistering.swift
//  Shifty
//
//  Created by 이민호 on 7/6/25.
//

import Foundation
import Resolver

protocol RepositoryRegistering {
    static func registerAllRepositories()
}

extension Resolver: RepositoryRegistering {
    public static func registerAllRepositories() {
        register { DefaultFolderRepository(context: resolve()) as FolderRepository }
        register { DefaultFileBookmarkRepository(context: resolve()) as FileBookmarkRepository}
        register { DefaultSnippetRepository(context: resolve()) as SnippetRepository}
    }
}


