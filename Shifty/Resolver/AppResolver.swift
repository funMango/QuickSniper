//
//  AppResolver.swift
//  Shifty
//
//  Created by 이민호 on 7/6/25.
//

import Foundation
import Resolver
import SwiftData

extension Resolver: @retroactive ResolverRegistering {
    public static func register() {
        registerSwiftData()
        registerAllRepositories()
        registerAllServices()
        registerAllSubjects()
    }
            
    static func registerSwiftData() {
        register{
            do {
                let container = try ModelContainer(for: Folder.self, Snippet.self, User.self, FileBookmarkItem.self)
                return container
            } catch {
                fatalError("Failed to create ModelContainer: \(error.localizedDescription)")
            }
        }.scope(.application)
        
        register {
            let container: ModelContainer = resolve()
            return ModelContext(container)
        }
    }
}



