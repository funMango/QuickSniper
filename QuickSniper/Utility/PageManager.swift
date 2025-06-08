//
//  PageManager.swift
//  QuickSniper
//
//  Created by 이민호 on 6/7/25.
//

import Foundation
import Combine
import AppKit

final class PageManager {
    private var pages: [Page] = []
    private let controllSubject: PassthroughSubject<ControllerMessage, Never>
    private var cancellables = Set<AnyCancellable>()
    private var previousApp: NSRunningApplication?
    
    init(controllSubject: PassthroughSubject<ControllerMessage, Never>) {
        self.controllSubject = controllSubject
        controllMessageBindings()
    }
    
    func controllMessageBindings() {
        controllSubject
            .sink { [weak self] message in
                guard let self else { return }
                
                switch message {
                case .switchPage(let page):
                    savePage(page)
                case .AutoHidePage(let page):
                    autoClosePage(page)
                case .escapePressed:
                    closePage()
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    private func savePage(_ page: Page) {
        pages.append(page)
        print("pages: \(pages)")
        controllSubject.send(page.getShowMessage())
    }
    
    private func closePage() {
        if pages.isEmpty { return }
        let page = pages.removeLast()
        controllSubject.send(page.getHideMessage())
        print("pages: \(pages) closePage")
    }
    
    private func autoClosePage(_ page: Page) {
       if let index = pages.firstIndex(of: page) {
           pages.remove(at: index)
       }
       print("pages: \(pages) autoClosePage")
    }
}
