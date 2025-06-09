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
    private var previousApps: [NSRunningApplication] = []
    
    init(controllSubject: PassthroughSubject<ControllerMessage, Never>) {
        self.controllSubject = controllSubject
        controllMessageBindings()
        let previousApp = NSWorkspace.shared.frontmostApplication
        
        if let previousApp = previousApp {
            previousApps.append(previousApp)
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
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
            
    private func savePage(_ page: Page) {
        guard let currentApp = NSWorkspace.shared.frontmostApplication else { return }
        previousApps.append(currentApp)
                
        DispatchQueue.main.async { [weak self] in
            self?.pages.append(page)
            self?.controllSubject.send(page.getShowMessage())
            NSApp.activate(ignoringOtherApps: true)
        }
    }
    
    private func closePage() {
        if pages.isEmpty { return }
        let page = pages.removeLast()
        controllSubject.send(page.getHideMessage())        
        
        restorePreviousAppFocus()
    }
    
    private func autoClosePage(_ page: Page) {
       if let index = pages.firstIndex(of: page) {
           pages.remove(at: index)
       }
        
        restorePreviousAppFocus()
    }
    
    private func restorePreviousAppFocus() {
        guard let lastApp = previousApps.popLast() else { return }
        lastApp.activate(options: [])
    }
}
