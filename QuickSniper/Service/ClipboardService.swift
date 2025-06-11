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
    private var snippet: Snippet?
    private var cancellables: Set<AnyCancellable> = []
    
    init(serviceSubject: CurrentValueSubject<ServiceMessage?, Never>) {
        self.serviceSubject = serviceSubject
        setupServiceMessageBinding()
    }
    
    func copy(_ snippet: Snippet) {
        print(snippet.body)
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(snippet.body, forType: .string)
    }
    
    private func setupServiceMessageBinding() {
        serviceSubject
            .sink { [weak self] message in
                switch message {
                case .copySnippetBody(let snippet):
                    print("Snippet: \(snippet.title)")
                    self?.copy(snippet)
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    
}
