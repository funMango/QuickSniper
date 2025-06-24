//
//  SidePanelViewModel.swift
//  QuickSniper
//
//  Created by 이민호 on 5/19/25.
//

import SwiftUI
import Combine
import SwiftData
import AppKit

final class PanelViewModel: ObservableObject, QuerySyncableObject {
    typealias Item = User
    @Published var allItems: [Item] = []
    @Published private var user: User?
    @Published var toast: ToastMessage?
    @Published var isToastVisible = false
    private let userUseCase: UserUseCase
    private let folderUseCase: FolderUseCase
    private let snippetUseCase: SnippetUseCase
    private let serviceSubject: CurrentValueSubject<ServiceMessage?, Never>
    private let hotCornerSubject: CurrentValueSubject<HotCornerMessage?, Never>
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        userUseCase: UserUseCase,
        folderUseCase: FolderUseCase,
        snippetUseCase: SnippetUseCase,
        serviceSubject: CurrentValueSubject<ServiceMessage?, Never>,
        hotCornerSubject: CurrentValueSubject<HotCornerMessage?, Never>
    ) {
        self.userUseCase = userUseCase
        self.folderUseCase = folderUseCase
        self.snippetUseCase = snippetUseCase
        self.serviceSubject = serviceSubject
        self.hotCornerSubject = hotCornerSubject
    }
    
    func getItems(_ items: [Item]) {
        self.allItems = items
                        
        guard let firstItem = allItems.first else {
            createUser()
            createWelcomeFolder()
            return
        }
        self.user = firstItem
    }
    
    func sendPressShortcutMessage(event: NSEvent) {
        serviceSubject.send(.pressShortcut(event))
    }
    
    private func createUser() {
        let user = User()
        
        do {
            try userUseCase.createUser(user)
        } catch {
            print("[ERROR]: AppMenuBarViewModel-createUser")
        }
    }
    
    private func createWelcomeFolder() {
        let folder = Folder(name: String(localized: "guide"), type: .snippet, order: 0)
        
        do {
            try folderUseCase.createFolder(folder)
            createWelcomeSnippet(folderId: folder.id)
        } catch {
            print("[ERROR]: PanelViewModel-createWelcomeFolder \(error)")
        }
    }
    
    private func createWelcomeSnippet(folderId: String) {
        DispatchQueue.main.async{ [weak self] in
            self?.snippetUseCase.createSnippet(
                folderId: folderId,
                title: String(localized: "welcome"),
                body: WelcomeContext.current
            )
        }
    }
}

//MARK: - Combine Bidnings
extension PanelViewModel {

}
