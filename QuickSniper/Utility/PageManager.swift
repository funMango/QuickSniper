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
        if pages.contains(page) { return }
        self.pages.append(page)
        self.controllSubject.send(page.getShowMessage())
    }
    
    private func closeAllPage() {
        while pages.count > 0 {
            let page = self.pages.removeLast()
            controllSubject.send(page.getHideMessage())
        }
    }
    
    private func closePage() {
        if pages.isEmpty { return }
        let page = pages.removeLast()
        controllSubject.send(page.getHideMessage())
        notifyDidHideMessage(from: page)
        
        sendFocus()
    }
    
    private func autoClosePage(_ page: Page) {
        if pages.isEmpty { return }
        if !pages.contains(page) { return }

        if let index = pages.firstIndex(of: page) {
            pages.remove(at: index)
            notifyDidHideMessage(from: page)
        }
        
        sendFocus()                
    }
    
    private func sendFocus() {
        if pages.contains(.panel) {
            controllSubject.send(.focusPanel)
        }
    }
    
    private func notifyDidHideMessage(from page: Page) {
        if let message = page.getDidHideMessage() {
            controllSubject.send(message)
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
