//
//  SubjectRegistering.swift
//  Shifty
//
//  Created by 이민호 on 7/6/25.
//

import Foundation
import Resolver
import Combine

protocol SubjectRegistering {
    static func registerAllSubjects()
}

extension Resolver: SubjectRegistering {
    public static func registerAllSubjects() {
        register {
            PassthroughSubject<ControllerMessage, Never>()
        }
        .scope(.application)
        
        register {
            CurrentValueSubject<CoreModelMessage?, Never>(nil)
        }
        .scope(.application)
        
        register {
            CurrentValueSubject<Folder?, Never>(nil)
        }
        .scope(.application)
        
        register {
            CurrentValueSubject<FolderMessage?, Never>(nil)
        }
        .scope(.application)
    }
}
