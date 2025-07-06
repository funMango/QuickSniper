//
//  ServiceRegistering.swift
//  Shifty
//
//  Created by 이민호 on 7/6/25.
//

import Foundation
import Resolver

protocol ServiceRegistering {
    static func registerAllServices()
}

extension Resolver: ServiceRegistering {
    public static func registerAllServices() {
        register{
            DefaultFileBookmarkService(repository: resolve()) as FileBookmarkService
        }
        .scope(.application)
        
        register{
            DefaultSnippetService(repository: resolve()) as SnippetService
        }
        .scope(.application)
        
       
        register{
            DefaultCoreModelService(
                snippetUsecase: resolve(),
                fileBookmarkUsecase: resolve()
            ) as CoreModelService
        }
        .scope(.application)
    }
}
