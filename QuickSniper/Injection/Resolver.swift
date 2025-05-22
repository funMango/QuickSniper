//
//  Resolver.swift
//  QuickSniper
//
//  Created by 이민호 on 5/22/25.
//

import Foundation
import Resolver


extension Resolver: @retroactive ResolverRegistering {
    public static func registerAllServices() {
        register { ControllerContainer() }
            .scope(.application)
    }
}
