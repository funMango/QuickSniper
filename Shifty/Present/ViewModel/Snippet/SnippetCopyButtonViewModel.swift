//
//  SnippetCopyButtonViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 6/10/25.
//

import Foundation
import Combine
import AppKit

final class SnippetCopyButtonViewModel: ObservableObject {
    private let snippetSubject: CurrentValueSubject<SnippetMessage?, Never>
    private let serviceSubject: CurrentValueSubject<ServiceMessage?, Never>
    private var cancellables: Set<AnyCancellable> = []
    private var snippet: Snippet?
    
    init(
        snippetSubject: CurrentValueSubject<SnippetMessage?, Never>,
        serviceSubject: CurrentValueSubject<ServiceMessage?, Never>
    ) {
        self.snippetSubject = snippetSubject
        self.serviceSubject = serviceSubject
        setUpSelectedSnippet()
    }
    
    func copy() {
        if let snippet = snippet {
            serviceSubject.send(.copySnippet(snippet))
        }        
    }
    
    private func setUpSelectedSnippet() {
        snippetSubject
            .sink { [weak self] message in
                switch message {
                case .snippetSelected(let snippet):
                    self?.snippet = snippet
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
}
