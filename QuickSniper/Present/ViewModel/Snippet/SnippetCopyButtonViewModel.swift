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
    private var cancellables: Set<AnyCancellable> = []
    private var snippet: Snippet?
    
    init(snippetSubject: CurrentValueSubject<SnippetMessage?, Never>) {
        self.snippetSubject = snippetSubject
        setUpSelectedSnippet()
    }
    
    func copy() {
        if let snippet = snippet {
            let pasteboard = NSPasteboard.general
            pasteboard.clearContents()
            pasteboard.setString(snippet.body, forType: .string)
        }
    }
    
    private func setUpSelectedSnippet() {
        snippetSubject
            .sink { [weak self] message in
                switch message {
                case .snippetSelected(let snippet):
                    print("스니펫: \(snippet.title)")
                    self?.snippet = snippet
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
}
