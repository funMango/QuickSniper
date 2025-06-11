//
//  ServiceContainer.swift
//  QuickSniper
//
//  Created by 이민호 on 6/10/25.
//

import Foundation
import Combine

enum ServiceMessage {
    case copySnippet(Snippet)
    case copySnippetBody(Snippet)
}

enum ServiceFuncMessage {
    
}

final class ServiceContainer {
    private let serviceSubject: CurrentValueSubject<ServiceMessage?, Never>
    private let snippetSubject: CurrentValueSubject<SnippetMessage?, Never>
    private var cancellables = Set<AnyCancellable>()
    
    private var clipboardService: ClipboardService?
    
    init(
        serviceSubject: CurrentValueSubject<ServiceMessage?, Never>,
        snippetSubject: CurrentValueSubject<SnippetMessage?, Never>
    ) {
        self.serviceSubject = serviceSubject
        self.snippetSubject = snippetSubject
        
        serviceMessageBindings()
    }
    
    
}

extension ServiceContainer {
    private func serviceMessageBindings() {
        serviceSubject
            .sink { [weak self] message in
                guard let self else { return }
                
                switch message {
                case .copySnippet(let snippet):
                    clipboardServiceInit()
                    serviceSubject.send(.copySnippetBody(snippet))
                default:
                    return
                }
            }
            .store(in: &cancellables)
    }
}

extension ServiceContainer {
    private func clipboardServiceInit() {
        if clipboardService == nil {
            self.clipboardService = ClipboardService(
                serviceSubject: serviceSubject
            )
        }
    }
}
