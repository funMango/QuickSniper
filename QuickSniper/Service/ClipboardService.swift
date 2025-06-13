//
//  ClipboardService.swift
//  QuickSniper
//
//  Created by 이민호 on 6/10/25.
//

import Foundation
import Combine
import AppKit

final class ClipboardService {
    private let serviceSubject: CurrentValueSubject<ServiceMessage?, Never>
    private var cancellables: Set<AnyCancellable> = []
    
    init(serviceSubject: CurrentValueSubject<ServiceMessage?, Never>) {
        self.serviceSubject = serviceSubject
        setupServiceMessageBinding()
    }
    
    func copy(_ snippet: Snippet) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(snippet.body, forType: .string)
        
        DispatchQueue.main.async{ [weak self] in
            self?.serviceSubject.send(.showCopyToast(snippet.title))
        }
    }
    
    private func setupServiceMessageBinding() {
        serviceSubject
            .sink { [weak self] message in
                switch message {
                case .copySnippetBody(let snippet):
                    self?.copy(snippet)
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
}
