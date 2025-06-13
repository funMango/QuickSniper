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
    private let userUseCase: UserUseCase
    private let serviceSubject: CurrentValueSubject<ServiceMessage?, Never>
    private let hotCornerSubject: CurrentValueSubject<HotCornerMessage?, Never>
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        userUseCase: UserUseCase,
        serviceSubject: CurrentValueSubject<ServiceMessage?, Never>,
        hotCornerSubject: CurrentValueSubject<HotCornerMessage?, Never>
    ) {
        self.userUseCase = userUseCase
        self.serviceSubject = serviceSubject
        self.hotCornerSubject = hotCornerSubject
                                
        setupUserBindings()
        setupControllMessageBindings()
    }
    
    func getItems(_ items: [Item]) {
        self.allItems = items
                        
        guard let firstItem = allItems.first else {
            createUser()
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
    
    private func updateHotCornerPosition(_ position: HotCornerPosition) {
        guard let user = user else { return }
                        
        user.updateHotCornerPosition(position)
        
        do {
            try userUseCase.updateUser(user)
        } catch {
            print("[ERROR]: AppMenuBarViewModel-updateUser")
        }
    }
}

extension PanelViewModel {
    private func setupUserBindings() {
        $user
            .compactMap { $0 }
            .first()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                guard let self = self else { return }
                                
                self.hotCornerSubject.send(.setupHotCornerPosition(user.hotCornerPosition))
            }
            .store(in: &cancellables)
    }
    
    private func setupControllMessageBindings() {
        hotCornerSubject
            .sink { [weak self] message in
                guard let self = self else { return }
                
                switch message {
                case .changeHotCornerPosition(let position):
                    self.updateHotCornerPosition(position)
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
}
