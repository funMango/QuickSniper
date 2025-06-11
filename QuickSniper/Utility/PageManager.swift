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
    
    init(controllSubject: PassthroughSubject<ControllerMessage, Never>) {
        self.controllSubject = controllSubject
        controllMessageBindings()
    }
            
    private func savePage(_ page: Page) {
        
        self.pages.append(page)
        self.controllSubject.send(page.getShowMessage())
        
        controllSubject.send(.windowFocus)
        
    }
    
    private func closeAllPage() {
        while pages.count > 0 {
            let page = self.pages.removeLast()
            self.controllSubject.send(page.getHideMessage())
        }
    }
    
    private func closePage() {
        if pages.isEmpty { return }
        let page = pages.removeLast()
        controllSubject.send(page.getHideMessage())
        
        if pages.count == 1 && pages[0] == .panel {
            controllSubject.send(.focusPanel)
        }
    }
    
    private func autoClosePage(_ page: Page) {
        if pages.isEmpty { return }
        pages.removeLast()
        
        if pages.count == 1 && pages[0] == .panel {
            controllSubject.send(.focusPanel)
        }
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
                case .allPageClose:
                     closeAllPage()
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
}
